/*
Copyright 2019 The Vitess Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package vreplication

import (
	"context"
	"errors"
	"fmt"
	"io"
	"math"
	"strconv"
	"strings"
	"time"

	"vitess.io/vitess/go/mysql/replication"
	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/binlog/binlogplayer"
	"vitess.io/vitess/go/vt/log"
	"vitess.io/vitess/go/vt/vterrors"
	vttablet "vitess.io/vitess/go/vt/vttablet/common"
	"vitess.io/vitess/go/vt/vttablet/tabletserver/throttle/throttlerapp"

	binlogdatapb "vitess.io/vitess/go/vt/proto/binlogdata"
)

const failedToRecordHeartbeatMsg = "failed to record heartbeat"

var (
	// At what point should we consider the vplayer to be stalled and return an error.
	// 5 minutes is well beyond a reasonable amount of time for a transaction to be
	// replicated.
	vplayerProgressDeadline = time.Duration(5 * time.Minute)

	// The error to return when we have detected a stall in the vplayer.
	errVPlayerStalled = errors.New("progress stalled; vplayer was unable to replicate the transaction in a timely manner; examine the target mysqld instance health and the replicated queries' EXPLAIN output to see why queries are taking unusually long")
)

// vplayer replays binlog events by pulling them from a vstreamer.
type vplayer struct {
	vr        *vreplicator
	startPos  replication.Position
	stopPos   replication.Position
	saveStop  bool
	copyState map[string]*sqltypes.Result

	replicatorPlan *ReplicatorPlan
	tablePlans     map[string]*TablePlan

	// These are set when creating the VPlayer based on whether the VPlayer
	// is in batch (stmt and trx) execution mode or not.
	query  func(ctx context.Context, sql string) (*sqltypes.Result, error)
	commit func() error
	// If the VPlayer is in batch mode, we accumulate each transaction's statements
	// that are then sent as a single multi-statement protocol request to the database.
	batchMode bool

	pos replication.Position
	// unsavedEvent is set any time we skip an event without
	// saving, which is on an empty commit.
	// If nothing else happens for idleTimeout since timeLastSaved,
	// the position of the unsavedEvent gets saved.
	unsavedEvent *binlogdatapb.VEvent
	// timeLastSaved is set every time a GTID is saved.
	timeLastSaved time.Time
	// lastTimestampNs is the last timestamp seen so far.
	lastTimestampNs int64
	// timeOffsetNs keeps track of the clock difference with respect to source tablet.
	timeOffsetNs int64
	// numAccumulatedHeartbeats keeps track of how many heartbeats have been received since we updated the time_updated column of _vt.vreplication
	numAccumulatedHeartbeats int

	// canAcceptStmtEvents is set to true if the current player can accept events in statement mode. Only true for filters that are match all.
	canAcceptStmtEvents bool

	phase string

	throttlerAppName string

	// See updateFKCheck for more details on how the two fields below are used.

	// foreignKeyChecksEnabled is the current state of the foreign key checks for the current session.
	// It reflects what we have set the @@session.foreign_key_checks session variable to.
	foreignKeyChecksEnabled bool

	// foreignKeyChecksStateInitialized is set to true once we have initialized the foreignKeyChecksEnabled.
	// The initialization is done on the first row event that this vplayer sees.
	foreignKeyChecksStateInitialized bool
}

// NoForeignKeyCheckFlagBitmask is the bitmask for the 2nd bit (least significant) of the flags in a binlog row event.
// This bit is set if foreign key checks are disabled.
const NoForeignKeyCheckFlagBitmask uint32 = 1 << 1

// newVPlayer creates a new vplayer. Parameters:
// vreplicator: the outer replicator. It's used for common functions like setState.
//
//	Also used to access the engine for registering journal events.
//
// settings: current settings read from _vt.vreplication.
// copyState: if set, contains the list of tables yet to be copied, or in the process
//
//	of being copied. If copyState is non-nil, the plans generated make sure that
//	replication is only applied to parts that have been copied so far.
//
// pausePos: if set, replication will stop at that position without updating the state to "Stopped".
//
//	This is used by the fastForward function during copying.
func newVPlayer(vr *vreplicator, settings binlogplayer.VRSettings, copyState map[string]*sqltypes.Result, pausePos replication.Position, phase string) *vplayer {
	saveStop := true
	if !pausePos.IsZero() {
		settings.StopPos = pausePos
		saveStop = false
	}
	log.Infof("Starting VReplication player id: %v, startPos: %v, stop: %v, filter: %+v",
		vr.id, settings.StartPos, settings.StopPos, vr.source.Filter)
	queryFunc := func(ctx context.Context, sql string) (*sqltypes.Result, error) {
		return vr.dbClient.ExecuteWithRetry(ctx, sql)
	}
	commitFunc := func() error {
		return vr.dbClient.Commit()
	}
	batchMode := false
	if vr.workflowConfig.ExperimentalFlags&vttablet.VReplicationExperimentalFlagVPlayerBatching != 0 {
		batchMode = true
	}
	if batchMode {
		// relayLogMaxSize is effectively the limit used when not batching.
		maxAllowedPacket := int64(vr.workflowConfig.RelayLogMaxSize)
		// We explicitly do NOT want to batch this, we want to send it down the wire
		// immediately so we use ExecuteFetch directly.
		res, err := vr.dbClient.ExecuteFetch(SqlMaxAllowedPacket, 1)
		if err != nil {
			log.Errorf("Error getting max_allowed_packet, will use the relay_log_max_size value of %d bytes: %v", vr.workflowConfig.RelayLogMaxSize, err)
		} else {
			if maxAllowedPacket, err = res.Rows[0][0].ToInt64(); err != nil {
				log.Errorf("Error getting max_allowed_packet, will use the relay_log_max_size value of %d bytes: %v", vr.workflowConfig.RelayLogMaxSize, err)
			}
		}
		// Leave 64 bytes of room for the commit to be sure that we have a more than
		// ample buffer left. The default value of max_allowed_packet is 4MiB in 5.7
		// and 64MiB in 8.0 -- and the default for max_relay_log_size is 250000
		// bytes -- so we have plenty of room.
		maxAllowedPacket -= 64
		queryFunc = func(ctx context.Context, sql string) (*sqltypes.Result, error) {
			if !vr.dbClient.InTransaction { // Should be sent down the wire immediately
				return vr.dbClient.Execute(sql)
			}
			return nil, vr.dbClient.AddQueryToTrxBatch(sql) // Should become part of the trx batch
		}
		commitFunc = func() error {
			return vr.dbClient.CommitTrxQueryBatch() // Commit the current trx batch
		}
		vr.dbClient.maxBatchSize = maxAllowedPacket
	}

	return &vplayer{
		vr:               vr,
		startPos:         settings.StartPos,
		pos:              settings.StartPos,
		stopPos:          settings.StopPos,
		saveStop:         saveStop,
		copyState:        copyState,
		timeLastSaved:    time.Now(),
		tablePlans:       make(map[string]*TablePlan),
		phase:            phase,
		throttlerAppName: throttlerapp.VPlayerName.ConcatenateString(vr.throttlerAppName()),
		query:            queryFunc,
		commit:           commitFunc,
		batchMode:        batchMode,
	}
}

// play is the entry point for playing binlogs.
func (vp *vplayer) play(ctx context.Context) error {
	if !vp.stopPos.IsZero() && vp.startPos.AtLeast(vp.stopPos) {
		log.Infof("Stop position %v already reached: %v", vp.startPos, vp.stopPos)
		if vp.saveStop {
			return vp.vr.setState(binlogdatapb.VReplicationWorkflowState_Stopped, fmt.Sprintf("Stop position %v already reached: %v", vp.startPos, vp.stopPos))
		}
		return nil
	}

	plan, err := vp.vr.buildReplicatorPlan(vp.vr.source, vp.vr.colInfoMap, vp.copyState, vp.vr.stats, vp.vr.vre.env.CollationEnv(), vp.vr.vre.env.Parser())
	if err != nil {
		vp.vr.stats.ErrorCounts.Add([]string{"Plan"}, 1)
		return err
	}
	vp.replicatorPlan = plan

	// We can't run in statement mode if there are filters defined.
	vp.canAcceptStmtEvents = true
	for _, rule := range vp.vr.source.Filter.Rules {
		if rule.Filter != "" || rule.Match != "/.*" {
			vp.canAcceptStmtEvents = false
			break
		}
	}

	return vp.fetchAndApply(ctx)
}

// updateFKCheck updates the @@session.foreign_key_checks variable based on the binlog row event flags.
// The function only does it if it has changed to avoid redundant updates, using the cached vplayer.foreignKeyChecksEnabled
// The foreign_key_checks value for a transaction is determined by the 2nd bit (least significant) of the flags:
// - If set (1), foreign key checks are disabled.
// - If unset (0), foreign key checks are enabled.
// updateFKCheck also updates the state for the first row event that this vplayer, and hence the db connection, sees.
func (vp *vplayer) updateFKCheck(ctx context.Context, flags2 uint32) error {
	mustUpdate := false
	if vp.vr.WorkflowSubType == int32(binlogdatapb.VReplicationWorkflowSubType_AtomicCopy) {
		// If this is an atomic copy, we must update the foreign_key_checks state even when the vplayer runs during
		// the copy phase, i.e., for catchup and fastforward.
		mustUpdate = true
	} else if vp.vr.state == binlogdatapb.VReplicationWorkflowState_Running {
		// If the vreplication workflow is in Running state, we must update the foreign_key_checks
		// state for all workflow types.
		mustUpdate = true
	}
	if !mustUpdate {
		return nil
	}
	dbForeignKeyChecksEnabled := true
	if flags2&NoForeignKeyCheckFlagBitmask == NoForeignKeyCheckFlagBitmask {
		dbForeignKeyChecksEnabled = false
	}

	if vp.foreignKeyChecksStateInitialized /* already set earlier */ &&
		dbForeignKeyChecksEnabled == vp.foreignKeyChecksEnabled /* no change in the state, no need to update */ {
		return nil
	}
	log.Infof("Setting this session's foreign_key_checks to %s", strconv.FormatBool(dbForeignKeyChecksEnabled))
	if _, err := vp.query(ctx, "set @@session.foreign_key_checks="+strconv.FormatBool(dbForeignKeyChecksEnabled)); err != nil {
		return fmt.Errorf("failed to set session foreign_key_checks: %w", err)
	}
	vp.foreignKeyChecksEnabled = dbForeignKeyChecksEnabled
	if !vp.foreignKeyChecksStateInitialized {
		log.Infof("First foreign_key_checks update to: %s", strconv.FormatBool(dbForeignKeyChecksEnabled))
		vp.foreignKeyChecksStateInitialized = true
	}
	return nil
}

// fetchAndApply performs the fetching and application of the binlogs.
// This is done by two different threads. The fetcher thread pulls
// events from the vstreamer and adds them to the relayLog.
// The applyEvents thread pulls accumulated events from the relayLog
// to apply them to mysql. The reason for this separation is because
// commits are slow during apply. So, more events can accumulate in
// the relay log during a commit. In such situations, the next iteration
// of apply combines all the transactions in the relay log into a single
// one. This allows for the apply thread to catch up more quickly if
// a backlog builds up.
func (vp *vplayer) fetchAndApply(ctx context.Context) (err error) {
	log.Infof("Starting VReplication player id: %v, startPos: %v, stop: %v, filter: %v", vp.vr.id, vp.startPos, vp.stopPos, vp.vr.source)

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	relay := newRelayLog(ctx, vp.vr.workflowConfig.RelayLogMaxItems, vp.vr.workflowConfig.RelayLogMaxSize)

	streamErr := make(chan error, 1)
	go func() {
		vstreamOptions := &binlogdatapb.VStreamOptions{
			ConfigOverrides: vp.vr.workflowConfig.Overrides,
		}
		streamErr <- vp.vr.sourceVStreamer.VStream(ctx, replication.EncodePosition(vp.startPos), nil,
			vp.replicatorPlan.VStreamFilter, func(events []*binlogdatapb.VEvent) error {
				return relay.Send(events)
			}, vstreamOptions)
	}()

	applyErr := make(chan error, 1)
	go func() {
		applyErr <- vp.applyEvents(ctx, relay)
	}()

	select {
	case err := <-applyErr:
		defer func() {
			// cancel and wait for the other thread to finish.
			cancel()
			<-streamErr
		}()

		// If the apply thread ends with io.EOF, it means either the Engine
		// is shutting down and canceled the context, or stop position was reached,
		// or a journal event was encountered.
		// If so, we return nil which will cause the controller to not retry.
		if err == io.EOF {
			return nil
		}
		return err
	case err := <-streamErr:
		defer func() {
			// cancel and wait for the other thread to finish.
			cancel()
			<-applyErr
		}()
		// If context is done, don't return an error.
		select {
		case <-ctx.Done():
			return nil
		default:
		}
		// If the stream ends normally we have to return an error indicating
		// that the controller has to retry a different vttablet.
		if err == nil || err == io.EOF {
			return errors.New("vstream ended")
		}
		return err
	}
}

// applyStmtEvent applies an actual DML statement received from the source, directly onto the backend database
func (vp *vplayer) applyStmtEvent(ctx context.Context, event *binlogdatapb.VEvent) error {
	sql := event.Statement
	if sql == "" {
		sql = event.Dml
	}
	if event.Type == binlogdatapb.VEventType_SAVEPOINT || vp.canAcceptStmtEvents {
		start := time.Now()
		_, err := vp.query(ctx, sql)
		vp.vr.stats.QueryTimings.Record(vp.phase, start)
		vp.vr.stats.QueryCount.Add(vp.phase, 1)
		return err
	}
	return fmt.Errorf("filter rules are not supported for SBR replication: %v", vp.vr.source.Filter.GetRules())
}

func (vp *vplayer) applyRowEvent(ctx context.Context, rowEvent *binlogdatapb.RowEvent) error {
	if err := vp.updateFKCheck(ctx, rowEvent.Flags); err != nil {
		return err
	}
	tplan := vp.tablePlans[rowEvent.TableName]
	if tplan == nil {
		return fmt.Errorf("unexpected event on table %s", rowEvent.TableName)
	}
	applyFunc := func(sql string) (*sqltypes.Result, error) {
		stats := NewVrLogStats("ROWCHANGE")
		start := time.Now()
		qr, err := vp.query(ctx, sql)
		vp.vr.stats.QueryCount.Add(vp.phase, 1)
		vp.vr.stats.QueryTimings.Record(vp.phase, start)
		stats.Send(sql)
		return qr, err
	}

	if vp.batchMode && len(rowEvent.RowChanges) > 1 {
		// If we have multiple delete row events for a table with a single PK column
		// then we can perform a simple bulk DELETE using an IN clause.
		if (rowEvent.RowChanges[0].Before != nil && rowEvent.RowChanges[0].After == nil) &&
			tplan.MultiDelete != nil {
			_, err := tplan.applyBulkDeleteChanges(rowEvent.RowChanges, applyFunc, vp.vr.dbClient.maxBatchSize)
			return err
		}
		// If we're done with the copy phase then we will be replicating all INSERTS
		// regardless of the PK value and can use a single INSERT statment with
		// multiple VALUES clauses.
		if len(vp.copyState) == 0 && (rowEvent.RowChanges[0].Before == nil && rowEvent.RowChanges[0].After != nil) {
			_, err := tplan.applyBulkInsertChanges(rowEvent.RowChanges, applyFunc, vp.vr.dbClient.maxBatchSize)
			return err
		}
	}

	for _, change := range rowEvent.RowChanges {
		if _, err := tplan.applyChange(change, applyFunc); err != nil {
			return err
		}
	}

	return nil
}

// updatePos should get called at a minimum of vreplicationMinimumHeartbeatUpdateInterval.
func (vp *vplayer) updatePos(ctx context.Context, ts int64) (posReached bool, err error) {
	update := binlogplayer.GenerateUpdatePos(vp.vr.id, vp.pos, time.Now().Unix(), ts, vp.vr.stats.CopyRowCount.Get(), vp.vr.workflowConfig.StoreCompressedGTID)
	if _, err := vp.query(ctx, update); err != nil {
		return false, fmt.Errorf("error %v updating position", err)
	}
	vp.numAccumulatedHeartbeats = 0
	vp.unsavedEvent = nil
	vp.timeLastSaved = time.Now()
	vp.vr.stats.SetLastPosition(vp.pos)
	posReached = !vp.stopPos.IsZero() && vp.pos.AtLeast(vp.stopPos)
	if posReached {
		log.Infof("Stopped at position: %v", vp.stopPos)
		if vp.saveStop {
			if err := vp.vr.setState(binlogdatapb.VReplicationWorkflowState_Stopped, fmt.Sprintf("Stopped at position %v", vp.stopPos)); err != nil {
				return false, err
			}
		}
	}
	return posReached, nil
}

func (vp *vplayer) mustUpdateHeartbeat() bool {
	return vp.numAccumulatedHeartbeats >= vp.vr.workflowConfig.HeartbeatUpdateInterval ||
		vp.numAccumulatedHeartbeats >= vreplicationMinimumHeartbeatUpdateInterval
}

func (vp *vplayer) recordHeartbeat() error {
	tm := time.Now().Unix()
	vp.vr.stats.RecordHeartbeat(tm)
	if !vp.mustUpdateHeartbeat() {
		return nil
	}
	if err := vp.vr.updateHeartbeatTime(tm); err != nil {
		return vterrors.Wrapf(errVPlayerStalled, "%s: %v", failedToRecordHeartbeatMsg, err)
	}
	// Only reset the pending heartbeat count if the update was successful.
	// Otherwise the vplayer may not actually be making progress and nobody
	// is aware of it -- resulting in the com_binlog_dump connection on the
	// source that is managed by the binlog_player getting closed by mysqld
	// when the source_net_timeout is hit.
	vp.numAccumulatedHeartbeats = 0
	return nil
}

// applyEvents is the main thread that applies the events. It has the following use
// cases to take into account:
//   - Normal transaction that has row mutations. In this case, the transaction
//     is committed along with an update of the position.
//   - DDL event: the action depends on the OnDDL setting.
//   - OTHER event: the current position of the event is saved.
//   - JOURNAL event: if the event is relevant to the current stream, invoke registerJournal
//     of the engine, and terminate.
//   - HEARTBEAT: update ReplicationLagSeconds.
//   - Empty transaction: The event is remembered as an unsavedEvent. If no commits
//     happen for idleTimeout since timeLastSaved, the current position of the unsavedEvent
//     is committed (updatePos).
//   - An empty transaction: Empty transactions are necessary because the current
//     position of that transaction may be the stop position. If so, we have to record it.
//     If not significant, we should avoid saving these empty transactions individually
//     because they can cause unnecessary churn and binlog bloat. We should
//     also not go for too long without saving because we should not fall way behind
//     on the current replication position. Additionally, WaitForPos or other external
//     agents could be waiting on that specific position by watching the vreplication
//     record.
//   - A group of transactions: Combine them into a single transaction.
//   - Partial transaction: Replay the events received so far and refetch from relay log
//     for more.
//   - A combination of any of the above: The trickier case is the one where a group
//     of transactions come in, with the last one being partial. In this case, all transactions
//     up to the last one have to be committed, and the final one must be partially applied.
//
// Of the above events, the saveable ones are COMMIT, DDL, and OTHER. Even though
// a GTID comes as a separate event, it's not saveable until a subsequent saveable
// event occurs. VStreamer currently sequences the GTID to be sent just before
// a saveable event, but we do not rely on this. To handle this, we only remember
// the position when a GTID is encountered. The next saveable event causes the
// current position to be saved.
//
// In order to handle the above use cases, we use an implicit transaction scheme:
// A BEGIN does not really start a transaction. Only a ROW event does. With this
// approach, no transaction gets started if an empty one arrives. If a we receive
// a commit, and a we are not in a transaction, we infer that the transaction was
// empty, and remember it as an unsaved event. The next GTID event will reset the
// unsaved event. If the next commit is also an empty transaction, then the latest
// one gets remembered as unsaved. A non-empty transaction, a must-save event,
// or a timeout will eventually cause the next save.
// The timeout (1s) plays another significant role: If the source and target shards of
// the replication are the same, then a commit of an unsaved event will generate
// another empty event. This is an infinite loop, and the timeout prevents
// this from becoming a tight loop.
// TODO(sougou): we can look at recognizing self-generated events and find a better
// way to handle them.
func (vp *vplayer) applyEvents(ctx context.Context, relay *relayLog) error {
	defer vp.vr.dbClient.Rollback()

	estimateLag := func() {
		behind := time.Now().UnixNano() - vp.lastTimestampNs - vp.timeOffsetNs
		vp.vr.stats.ReplicationLagSeconds.Store(behind / 1e9)
		vp.vr.stats.VReplicationLags.Add(strconv.Itoa(int(vp.vr.id)), time.Duration(behind/1e9)*time.Second)
	}

	// If we're not running, set ReplicationLagSeconds to be very high.
	// TODO(sougou): if we also stored the time of the last event, we
	// can estimate this value more accurately.
	defer vp.vr.stats.ReplicationLagSeconds.Store(math.MaxInt64)
	defer vp.vr.stats.VReplicationLags.Add(strconv.Itoa(int(vp.vr.id)), math.MaxInt64)
	var lagSecs int64
	for {
		if ctx.Err() != nil {
			return ctx.Err()
		}
		// Check throttler.
		if checkResult, ok := vp.vr.vre.throttlerClient.ThrottleCheckOKOrWaitAppName(ctx, throttlerapp.Name(vp.throttlerAppName)); !ok {
			_ = vp.vr.updateTimeThrottled(throttlerapp.VPlayerName, checkResult.Summary())
			estimateLag()
			continue
		}

		items, err := relay.Fetch()
		if err != nil {
			return err
		}

		// Empty transactions are saved at most once every idleTimeout.
		// This covers two situations:
		// 1. Fetch was idle for idleTimeout.
		// 2. We've been receiving empty events for longer than idleTimeout.
		// In both cases, now > timeLastSaved. If so, the GTID of the last unsavedEvent
		// must be saved.
		if time.Since(vp.timeLastSaved) >= idleTimeout && vp.unsavedEvent != nil {
			posReached, err := vp.updatePos(ctx, vp.unsavedEvent.Timestamp)
			if err != nil {
				return err
			}
			if posReached {
				// Unreachable.
				return nil
			}
		}

		lagSecs = -1
		for i, events := range items {
			for j, event := range events {
				if event.Timestamp != 0 {
					// If the event is a heartbeat sent while throttled then do not update
					// the lag based on it.
					// If the batch consists only of throttled heartbeat events then we cannot
					// determine the actual lag, as the vstreamer is fully throttled, and we
					// will estimate it after processing the batch.
					if !(event.Type == binlogdatapb.VEventType_HEARTBEAT && event.Throttled) {
						vp.lastTimestampNs = event.Timestamp * 1e9
						vp.timeOffsetNs = time.Now().UnixNano() - event.CurrentTime
						lagSecs = event.CurrentTime/1e9 - event.Timestamp
					}
				}
				mustSave := false
				switch event.Type {
				case binlogdatapb.VEventType_COMMIT:
					// If we've reached the stop position, we must save the current commit
					// even if it's empty. So, the next applyEvent is invoked with the
					// mustSave flag.
					if !vp.stopPos.IsZero() && vp.pos.AtLeast(vp.stopPos) {
						mustSave = true
						break
					}
					// In order to group multiple commits into a single one, we look ahead for
					// the next commit. If there is one, we skip the current commit, which ends up
					// applying the next set of events as part of the current transaction. This approach
					// also handles the case where the last transaction is partial. In that case,
					// we only group the transactions with commits we've seen so far.
					if hasAnotherCommit(items, i, j+1) {
						continue
					}
				}
				if err := vp.applyEvent(ctx, event, mustSave); err != nil {
					if err != io.EOF {
						vp.vr.stats.ErrorCounts.Add([]string{"Apply"}, 1)
						var table, tableLogMsg, gtidLogMsg string
						switch {
						case event.GetFieldEvent() != nil:
							table = event.GetFieldEvent().TableName
						case event.GetRowEvent() != nil:
							table = event.GetRowEvent().TableName
						}
						if table != "" {
							tableLogMsg = fmt.Sprintf(" for table %s", table)
						}
						pos := getNextPosition(items, i, j+1)
						if pos != "" {
							gtidLogMsg = fmt.Sprintf(" while processing position %s", pos)
						}
						log.Errorf("Error applying event%s%s: %s", tableLogMsg, gtidLogMsg, err.Error())
						err = vterrors.Wrapf(err, "error applying event%s%s", tableLogMsg, gtidLogMsg)
					}
					return err
				}
			}
		}

		if lagSecs >= 0 {
			vp.vr.stats.ReplicationLagSeconds.Store(lagSecs)
			vp.vr.stats.VReplicationLags.Add(strconv.Itoa(int(vp.vr.id)), time.Duration(lagSecs)*time.Second)
		} else { // We couldn't determine the lag, so we need to estimate it
			estimateLag()
		}
	}
}

func hasAnotherCommit(items [][]*binlogdatapb.VEvent, i, j int) bool {
	for i < len(items) {
		for j < len(items[i]) {
			// We skip GTID, BEGIN, FIELD, ROW and DMLs.
			switch items[i][j].Type {
			case binlogdatapb.VEventType_COMMIT:
				return true
			case binlogdatapb.VEventType_DDL, binlogdatapb.VEventType_OTHER, binlogdatapb.VEventType_JOURNAL:
				return false
			}
			j++
		}
		j = 0
		i++
	}
	return false
}

// getNextPosition returns the GTID set/position we would be at if the current
// transaction was committed. This is useful for error handling as we can then
// determine which GTID we're failing to process from the source and examine the
// binlog events for that GTID directly on the source to debug the issue.
// This is needed as it's not as simple as the user incrementing the current
// position in the stream by 1 as we may be skipping N intermediate GTIDs in the
// stream due to filtering. For GTIDs that we filter out we still replicate the
// GTID event itself, just without any internal events and a COMMIT event (see
// the unsavedEvent handling).
func getNextPosition(items [][]*binlogdatapb.VEvent, i, j int) string {
	for i < len(items) {
		for j < len(items[i]) {
			switch items[i][j].Type {
			case binlogdatapb.VEventType_GTID:
				pos, err := binlogplayer.DecodePosition(items[i][j].Gtid)
				if err != nil {
					return ""
				}
				return pos.String()
			}
			j++
		}
		j = 0
		i++
	}
	return ""
}

func (vp *vplayer) applyEvent(ctx context.Context, event *binlogdatapb.VEvent, mustSave bool) error {
	stats := NewVrLogStats(event.Type.String())
	switch event.Type {
	case binlogdatapb.VEventType_GTID:
		pos, err := binlogplayer.DecodePosition(event.Gtid)
		if err != nil {
			return err
		}
		vp.pos = pos
		// A new position should not be saved until a saveable event occurs.
		vp.unsavedEvent = nil
		if vp.stopPos.IsZero() {
			return nil
		}
	case binlogdatapb.VEventType_BEGIN:
		// No-op: begin is called as needed.
	case binlogdatapb.VEventType_COMMIT:
		if mustSave {
			if err := vp.vr.dbClient.Begin(); err != nil {
				return err
			}
		}

		if !vp.vr.dbClient.InTransaction {
			// We're skipping an empty transaction. We may have to save the position on inactivity.
			vp.unsavedEvent = event
			return nil
		}
		posReached, err := vp.updatePos(ctx, event.Timestamp)
		if err != nil {
			return err
		}
		if err := vp.commit(); err != nil {
			return err
		}
		if posReached {
			return io.EOF
		}
	case binlogdatapb.VEventType_FIELD:
		if err := vp.vr.dbClient.Begin(); err != nil {
			return err
		}
		tplan, err := vp.replicatorPlan.buildExecutionPlan(event.FieldEvent)
		if err != nil {
			return err
		}
		vp.tablePlans[event.FieldEvent.TableName] = tplan
		stats.Send(fmt.Sprintf("%v", event.FieldEvent))

	case binlogdatapb.VEventType_INSERT, binlogdatapb.VEventType_DELETE, binlogdatapb.VEventType_UPDATE,
		binlogdatapb.VEventType_REPLACE, binlogdatapb.VEventType_SAVEPOINT:
		// use event.Statement if available, preparing for deprecation in 8.0
		sql := event.Statement
		if sql == "" {
			sql = event.Dml
		}
		// If the event is for one of the AWS RDS "special" or pt-table-checksum tables, we skip
		if !strings.Contains(sql, " mysql.rds_") && !strings.Contains(sql, " percona.checksums") {
			// This is a player using statement based replication
			if err := vp.vr.dbClient.Begin(); err != nil {
				return err
			}
			if err := vp.applyStmtEvent(ctx, event); err != nil {
				return err
			}
			stats.Send(sql)
		}
	case binlogdatapb.VEventType_ROW:
		// This player is configured for row based replication
		if err := vp.vr.dbClient.Begin(); err != nil {
			return err
		}
		if err := vp.applyRowEvent(ctx, event.RowEvent); err != nil {
			log.Infof("Error applying row event: %s", err.Error())
			return err
		}
		// Row event is logged AFTER RowChanges are applied so as to calculate the total elapsed
		// time for the Row event.
		stats.Send(fmt.Sprintf("%v", event.RowEvent))
	case binlogdatapb.VEventType_OTHER:
		if vp.vr.dbClient.InTransaction {
			// Unreachable
			log.Errorf("internal error: vplayer is in a transaction on event: %v", event)
			return fmt.Errorf("internal error: vplayer is in a transaction on event: %v", event)
		}
		// Just update the position.
		posReached, err := vp.updatePos(ctx, event.Timestamp)
		if err != nil {
			return err
		}
		if posReached {
			return io.EOF
		}
	case binlogdatapb.VEventType_DDL:
		if vp.vr.dbClient.InTransaction {
			// Unreachable
			log.Errorf("internal error: vplayer is in a transaction on event: %v", event)
			return fmt.Errorf("internal error: vplayer is in a transaction on event: %v", event)
		}
		vp.vr.stats.DDLEventActions.Add(vp.vr.source.OnDdl.String(), 1) // Record the DDL handling
		switch vp.vr.source.OnDdl {
		case binlogdatapb.OnDDLAction_IGNORE:
			// We still have to update the position.
			posReached, err := vp.updatePos(ctx, event.Timestamp)
			if err != nil {
				return err
			}
			if posReached {
				return io.EOF
			}
		case binlogdatapb.OnDDLAction_STOP:
			if err := vp.vr.dbClient.Begin(); err != nil {
				return err
			}
			if _, err := vp.updatePos(ctx, event.Timestamp); err != nil {
				return err
			}
			if err := vp.vr.setState(binlogdatapb.VReplicationWorkflowState_Stopped, fmt.Sprintf("Stopped at DDL %s", event.Statement)); err != nil {
				return err
			}
			if err := vp.commit(); err != nil {
				return err
			}
			return io.EOF
		case binlogdatapb.OnDDLAction_EXEC:
			// It's impossible to save the position transactionally with the statement.
			// So, we apply the DDL first, and then save the position.
			// Manual intervention may be needed if there is a partial
			// failure here.
			if _, err := vp.query(ctx, event.Statement); err != nil {
				return err
			}
			stats.Send(fmt.Sprintf("%v", event.Statement))
			posReached, err := vp.updatePos(ctx, event.Timestamp)
			if err != nil {
				return err
			}
			if posReached {
				return io.EOF
			}
		case binlogdatapb.OnDDLAction_EXEC_IGNORE:
			if _, err := vp.query(ctx, event.Statement); err != nil {
				log.Infof("Ignoring error: %v for DDL: %s", err, event.Statement)
			}
			stats.Send(fmt.Sprintf("%v", event.Statement))
			posReached, err := vp.updatePos(ctx, event.Timestamp)
			if err != nil {
				return err
			}
			if posReached {
				return io.EOF
			}
		}
	case binlogdatapb.VEventType_JOURNAL:
		if vp.vr.dbClient.InTransaction {
			// Unreachable
			log.Errorf("internal error: vplayer is in a transaction on event: %v", event)
			return fmt.Errorf("internal error: vplayer is in a transaction on event: %v", event)
		}
		// Ensure that we don't have a partial set of table matches in the journal.
		switch event.Journal.MigrationType {
		case binlogdatapb.MigrationType_SHARDS:
			// All tables of the source were migrated. So, no validation needed.
		case binlogdatapb.MigrationType_TABLES:
			// Validate that all or none of the tables are in the journal.
			jtables := make(map[string]bool)
			for _, table := range event.Journal.Tables {
				jtables[table] = true
			}
			found := false
			notFound := false
			for tableName := range vp.replicatorPlan.TablePlans {
				if _, ok := jtables[tableName]; ok {
					found = true
				} else {
					notFound = true
				}
			}
			switch {
			case found && notFound:
				// Some were found and some were not found. We can't handle this.
				if err := vp.vr.setState(binlogdatapb.VReplicationWorkflowState_Stopped, "unable to handle journal event: tables were partially matched"); err != nil {
					return err
				}
				return io.EOF
			case notFound:
				// None were found. Ignore journal.
				return nil
			}
			// All were found. We must register journal.
		}
		log.Infof("Binlog event registering journal event %+v", event.Journal)
		if err := vp.vr.vre.registerJournal(event.Journal, vp.vr.id); err != nil {
			if err := vp.vr.setState(binlogdatapb.VReplicationWorkflowState_Stopped, err.Error()); err != nil {
				return err
			}
			return io.EOF
		}
		stats.Send(fmt.Sprintf("%v", event.Journal))
		return io.EOF
	case binlogdatapb.VEventType_HEARTBEAT:
		if event.Throttled {
			if err := vp.vr.updateTimeThrottled(throttlerapp.VStreamerName, event.ThrottledReason); err != nil {
				return err
			}
		}
		if !vp.vr.dbClient.InTransaction {
			vp.numAccumulatedHeartbeats++
			if err := vp.recordHeartbeat(); err != nil {
				return err
			}
		}
	}

	return nil
}
