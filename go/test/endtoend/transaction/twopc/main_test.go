/*
Copyright 2024 The Vitess Authors.

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

package transaction

import (
	"context"
	_ "embed"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/mysql"
	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/test/endtoend/cluster"
	"vitess.io/vitess/go/test/endtoend/transaction/twopc/utils"
	binlogdatapb "vitess.io/vitess/go/vt/proto/binlogdata"
	querypb "vitess.io/vitess/go/vt/proto/query"
	topodatapb "vitess.io/vitess/go/vt/proto/topodata"
	"vitess.io/vitess/go/vt/vtgate/vtgateconn"
)

var (
	clusterInstance   *cluster.LocalProcessCluster
	vtParams          mysql.ConnParams
	vtgateGrpcAddress string
	keyspaceName      = "ks"
	cell              = "zone1"
	hostname          = "localhost"
	sidecarDBName     = "vt_ks"

	//go:embed schema.sql
	SchemaSQL string

	//go:embed vschema.json
	VSchema string
)

func TestMain(m *testing.M) {
	flag.Parse()

	exitcode := func() int {
		clusterInstance = cluster.NewCluster(cell, hostname)
		defer clusterInstance.Teardown()

		// Start topo server
		if err := clusterInstance.StartTopo(); err != nil {
			return 1
		}

		// Reserve vtGate port in order to pass it to vtTablet
		clusterInstance.VtgateGrpcPort = clusterInstance.GetAndReservePort()

		// Set extra args for twopc
		clusterInstance.VtGateExtraArgs = append(clusterInstance.VtGateExtraArgs,
			"--transaction_mode", "TWOPC",
			"--grpc_use_effective_callerid",
		)
		clusterInstance.VtTabletExtraArgs = append(clusterInstance.VtTabletExtraArgs,
			"--twopc_enable",
			"--twopc_abandon_age", "1",
			"--queryserver-config-transaction-cap", "3",
		)

		// Start keyspace
		keyspace := &cluster.Keyspace{
			Name:             keyspaceName,
			SchemaSQL:        SchemaSQL,
			VSchema:          VSchema,
			SidecarDBName:    sidecarDBName,
			DurabilityPolicy: "semi_sync",
		}
		if err := clusterInstance.StartKeyspace(*keyspace, []string{"-40", "40-80", "80-"}, 2, false); err != nil {
			return 1
		}

		// Start Vtgate
		if err := clusterInstance.StartVtgate(); err != nil {
			return 1
		}
		vtParams = clusterInstance.GetVTParams(keyspaceName)
		vtgateGrpcAddress = fmt.Sprintf("%s:%d", clusterInstance.Hostname, clusterInstance.VtgateGrpcPort)

		return m.Run()
	}()
	os.Exit(exitcode)
}

func start(t *testing.T) (*mysql.Conn, func()) {
	ctx := context.Background()
	conn, err := mysql.Connect(ctx, &vtParams)
	require.NoError(t, err)
	cleanup(t)

	return conn, func() {
		conn.Close()
		cleanup(t)
	}
}

func cleanup(t *testing.T) {
	utils.ClearOutTable(t, vtParams, "twopc_user")
	utils.ClearOutTable(t, vtParams, "twopc_t1")
}

type extractInterestingValues func(dtidMap map[string]string, vals []sqltypes.Value) []sqltypes.Value

var tables = map[string]extractInterestingValues{
	"ks.dt_state": func(dtidMap map[string]string, vals []sqltypes.Value) (out []sqltypes.Value) {
		dtid := getDTID(dtidMap, vals[0].ToString())
		dtState := getDTState(vals[1])
		out = append(out, sqltypes.NewVarChar(dtid), sqltypes.NewVarChar(dtState.String()))
		return
	},
	"ks.dt_participant": func(dtidMap map[string]string, vals []sqltypes.Value) (out []sqltypes.Value) {
		dtid := getDTID(dtidMap, vals[0].ToString())
		out = append([]sqltypes.Value{sqltypes.NewVarChar(dtid)}, vals[1:]...)
		return
	},
	"ks.redo_state": func(dtidMap map[string]string, vals []sqltypes.Value) (out []sqltypes.Value) {
		dtid := getDTID(dtidMap, vals[0].ToString())
		dtState := getDTState(vals[1])
		out = append(out, sqltypes.NewVarChar(dtid), sqltypes.NewVarChar(dtState.String()))
		return
	},
	"ks.redo_statement": func(dtidMap map[string]string, vals []sqltypes.Value) (out []sqltypes.Value) {
		dtid := getDTID(dtidMap, vals[0].ToString())
		out = append([]sqltypes.Value{sqltypes.NewVarChar(dtid)}, vals[1:]...)
		return
	},
	"ks.twopc_user": func(_ map[string]string, vals []sqltypes.Value) []sqltypes.Value { return vals },
}

func getDTState(val sqltypes.Value) querypb.TransactionState {
	s, _ := val.ToInt()
	return querypb.TransactionState(s)
}

func getDTID(dtidMap map[string]string, dtKey string) string {
	dtid, exists := dtidMap[dtKey]
	if !exists {
		dtid = fmt.Sprintf("dtid-%d", len(dtidMap)+1)
		dtidMap[dtKey] = dtid
	}
	return dtid
}

func runVStream(t *testing.T, ctx context.Context, ch chan *binlogdatapb.VEvent, vtgateConn *vtgateconn.VTGateConn) {
	shards := []string{"-40", "40-80", "80-"}
	shardGtids := make([]*binlogdatapb.ShardGtid, 0, len(shards))
	var seen = make(map[string]bool, len(shards))
	var wg sync.WaitGroup
	for _, shard := range shards {
		shardGtids = append(shardGtids, &binlogdatapb.ShardGtid{Keyspace: keyspaceName, Shard: shard, Gtid: "current"})
		seen[shard] = false
		wg.Add(1)
	}
	vgtid := &binlogdatapb.VGtid{ShardGtids: shardGtids}
	filter := &binlogdatapb.Filter{Rules: []*binlogdatapb.Rule{{Match: "/.*/"}}}

	vReader, err := vtgateConn.VStream(ctx, topodatapb.TabletType_PRIMARY, vgtid, filter, nil)
	require.NoError(t, err)

	go func() {
		for {
			evs, err := vReader.Recv()
			if err == io.EOF || ctx.Err() != nil {
				return
			}
			require.NoError(t, err)

			for _, ev := range evs {
				// Mark VGTID event from each shard seen.
				if ev.Type == binlogdatapb.VEventType_VGTID {
					if !seen[ev.Shard] {
						seen[ev.Shard] = true
						wg.Done()
					}
				}
				if ev.Type == binlogdatapb.VEventType_ROW || ev.Type == binlogdatapb.VEventType_FIELD {
					ch <- ev
				}
			}
		}
	}()

	// Wait for VGTID event from all shards
	wg.Wait()
}

func retrieveTransitions(t *testing.T, ch chan *binlogdatapb.VEvent, tableMap map[string][]*querypb.Field, dtMap map[string]string) map[string][]string {
	return retrieveTransitionsWithTimeout(t, ch, tableMap, dtMap, 1*time.Second)
}

func retrieveTransitionsWithTimeout(t *testing.T, ch chan *binlogdatapb.VEvent, tableMap map[string][]*querypb.Field, dtMap map[string]string, timeout time.Duration) map[string][]string {
	logTable := make(map[string][]string)

	keepWaiting := true
	for keepWaiting {
		select {
		case re := <-ch:
			if re.RowEvent != nil {
				shard := re.RowEvent.Shard
				tableName := re.RowEvent.TableName
				fields, ok := tableMap[tableName]
				require.Truef(t, ok, "table %s not found in fields map", tableName)
				for _, rc := range re.RowEvent.RowChanges {
					logEvent(logTable, dtMap, shard, tableName, fields, rc)
				}
			}
			if re.FieldEvent != nil {
				tableMap[re.FieldEvent.TableName] = re.FieldEvent.Fields
			}
		case <-time.After(timeout):
			keepWaiting = false
		}
	}
	return logTable
}

func logEvent(logTable map[string][]string, dtMap map[string]string, shard string, tbl string, fields []*querypb.Field, rc *binlogdatapb.RowChange) {
	key := fmt.Sprintf("%s:%s", tbl, shard)

	var eventType string
	var vals []sqltypes.Value
	switch {
	case rc.Before == nil && rc.After == nil:
		panic("do not expect row event with both before and after nil")
	case rc.Before == nil:
		eventType = "insert"
		vals = sqltypes.MakeRowTrusted(fields, rc.After)
	case rc.After == nil:
		eventType = "delete"
		vals = sqltypes.MakeRowTrusted(fields, rc.Before)
	default:
		eventType = "update"
		vals = sqltypes.MakeRowTrusted(fields, rc.After)
	}
	execFunc, exists := tables[tbl]
	if exists {
		vals = execFunc(dtMap, vals)
	}
	logTable[key] = append(logTable[key], fmt.Sprintf("%s:%v", eventType, vals))
}

func prettyPrint(v interface{}) string {
	b, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return fmt.Sprintf("got error marshalling: %v", err)
	}
	return string(b)
}
