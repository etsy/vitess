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

package mysql

import (
	"encoding/binary"
	"fmt"

	"vitess.io/vitess/go/mysql/replication"
)

// filePosBinlogEvent wraps a raw packet buffer and provides methods to examine
// it by implementing BinlogEvent. Some methods are pulled in from binlogEvent.
type filePosBinlogEvent struct {
	binlogEvent
	semiSyncAckRequested bool
}

// newFilePosBinlogEventWithSemiSyncInfo creates a BinlogEvent from given byte array
func newFilePosBinlogEventWithSemiSyncInfo(buf []byte, semiSyncAckRequested bool) *filePosBinlogEvent {
	return &filePosBinlogEvent{binlogEvent: binlogEvent(buf), semiSyncAckRequested: semiSyncAckRequested}
}

// newFilePosBinlogEvent creates a BinlogEvent from given byte array
func newFilePosBinlogEvent(buf []byte) *filePosBinlogEvent {
	return &filePosBinlogEvent{binlogEvent: binlogEvent(buf)}
}

func (*filePosBinlogEvent) GTID(BinlogFormat) (replication.GTID, bool, error) {
	return nil, false, nil
}

// IsSemiSyncAckRequested implements BinlogEvent.IsSemiSyncAckRequested().
func (ev *filePosBinlogEvent) IsSemiSyncAckRequested() bool {
	return ev.semiSyncAckRequested
}

func (*filePosBinlogEvent) IsGTID() bool {
	return false
}

func (*filePosBinlogEvent) PreviousGTIDs(BinlogFormat) (replication.Position, error) {
	return replication.Position{}, fmt.Errorf("filePos should not provide PREVIOUS_GTIDS_EVENT events")
}

// StripChecksum implements BinlogEvent.StripChecksum().
func (ev *filePosBinlogEvent) StripChecksum(f BinlogFormat) (BinlogEvent, []byte, error) {
	switch f.ChecksumAlgorithm {
	case BinlogChecksumAlgOff, BinlogChecksumAlgUndef:
		// There is no checksum.
		return ev, nil, nil
	default:
		// Checksum is the last 4 bytes of the event buffer.
		data := ev.Bytes()
		length := len(data)
		checksum := data[length-4:]
		data = data[:length-4]
		return newFilePosBinlogEvent(data), checksum, nil
	}
}

// nextPosition returns the next file position of the binlog.
// If no information is available, it returns 0.
func (ev *filePosBinlogEvent) nextPosition(f BinlogFormat) uint64 {
	if f.HeaderLength <= 13 {
		// Dead code. This is just a failsafe.
		return 0
	}
	// The header only uses 4 bytes for the next_position.
	return uint64(binary.LittleEndian.Uint32(ev.Bytes()[13:17]))
}

// rotate implements BinlogEvent.Rotate().
//
// Expected format (L = total length of event data):
//
//	# bytes  field
//	8        position
//	8:L      file
func (ev *filePosBinlogEvent) rotate(f BinlogFormat) (int, string) {
	data := ev.Bytes()[f.HeaderLength:]
	pos := binary.LittleEndian.Uint64(data[0:8])
	file := data[8:]
	return int(pos), string(file)
}

//----------------------------------------------------------------------------

// filePosQueryEvent is a fake begin event.
type filePosQueryEvent struct {
	query string
	filePosFakeEvent
}

func newFilePosQueryEvent(query string, ts uint32) filePosQueryEvent {
	return filePosQueryEvent{
		query: query,
		filePosFakeEvent: filePosFakeEvent{
			timestamp: ts,
		},
	}
}

func (ev filePosQueryEvent) IsQuery() bool {
	return true
}

func (ev filePosQueryEvent) Query(BinlogFormat) (Query, error) {
	return Query{
		SQL: ev.query,
	}, nil
}

func (ev filePosQueryEvent) StripChecksum(f BinlogFormat) (BinlogEvent, []byte, error) {
	return ev, nil, nil
}

func (ev filePosQueryEvent) Bytes() []byte {
	return []byte{}
}

//----------------------------------------------------------------------------

// filePosFakeEvent is the base class for fake events.
type filePosFakeEvent struct {
	timestamp uint32
}

func (ev filePosFakeEvent) NextPosition() uint64 {
	return 0
}

func (ev filePosFakeEvent) IsValid() bool {
	return true
}

func (ev filePosFakeEvent) IsFormatDescription() bool {
	return false
}

func (ev filePosFakeEvent) IsQuery() bool {
	return false
}

func (ev filePosFakeEvent) IsXID() bool {
	return false
}

func (ev filePosFakeEvent) IsStop() bool {
	return false
}

func (ev filePosFakeEvent) IsSemiSyncAckRequested() bool {
	return false
}

func (ev filePosFakeEvent) IsGTID() bool {
	return false
}

func (ev filePosFakeEvent) IsRotate() bool {
	return false
}

func (ev filePosFakeEvent) IsIntVar() bool {
	return false
}

func (ev filePosFakeEvent) IsRand() bool {
	return false
}

func (ev filePosFakeEvent) IsPreviousGTIDs() bool {
	return false
}

func (ev filePosFakeEvent) IsHeartbeat() bool {
	return false
}

func (ev filePosFakeEvent) IsTableMap() bool {
	return false
}

func (ev filePosFakeEvent) IsWriteRows() bool {
	return false
}

func (ev filePosFakeEvent) IsUpdateRows() bool {
	return false
}

func (ev filePosFakeEvent) IsDeleteRows() bool {
	return false
}

func (ev filePosFakeEvent) Timestamp() uint32 {
	return ev.timestamp
}

func (ev filePosFakeEvent) ServerID() uint32 {
	return 1
}

func (ev filePosFakeEvent) Format() (BinlogFormat, error) {
	return BinlogFormat{}, nil
}

func (ev filePosFakeEvent) GTID(BinlogFormat) (replication.GTID, bool, error) {
	return nil, false, nil
}

func (ev filePosFakeEvent) Query(BinlogFormat) (Query, error) {
	return Query{}, nil
}

func (ev filePosFakeEvent) IntVar(BinlogFormat) (byte, uint64, error) {
	return 0, 0, nil
}

func (ev filePosFakeEvent) Rand(BinlogFormat) (uint64, uint64, error) {
	return 0, 0, nil
}

func (ev filePosFakeEvent) PreviousGTIDs(BinlogFormat) (replication.Position, error) {
	return replication.Position{}, nil
}

func (ev filePosFakeEvent) TableID(BinlogFormat) uint64 {
	return 0
}

func (ev filePosFakeEvent) TableMap(BinlogFormat) (*TableMap, error) {
	return nil, nil
}

func (ev filePosFakeEvent) Rows(BinlogFormat, *TableMap) (Rows, error) {
	return Rows{}, nil
}

func (ev filePosFakeEvent) TransactionPayload(BinlogFormat) (*TransactionPayload, error) {
	return &TransactionPayload{}, nil
}

func (ev filePosFakeEvent) NextLogFile(BinlogFormat) (string, uint64, error) {
	return "", 0, nil
}

func (ev filePosFakeEvent) IsPseudo() bool {
	return false
}

func (ev filePosFakeEvent) IsTransactionPayload() bool {
	return false
}

func (ev filePosFakeEvent) Bytes() []byte {
	return []byte{}
}

//----------------------------------------------------------------------------

// filePosGTIDEvent is a fake GTID event for filePos.
type filePosGTIDEvent struct {
	filePosFakeEvent
	gtid replication.FilePosGTID
}

func newFilePosGTIDEvent(file string, pos uint64, timestamp uint32) filePosGTIDEvent {
	return filePosGTIDEvent{
		filePosFakeEvent: filePosFakeEvent{
			timestamp: timestamp,
		},
		gtid: replication.FilePosGTID{
			File: file,
			Pos:  pos,
		},
	}
}

func (ev filePosGTIDEvent) IsGTID() bool {
	return true
}

func (ev filePosGTIDEvent) StripChecksum(f BinlogFormat) (BinlogEvent, []byte, error) {
	return ev, nil, nil
}

func (ev filePosGTIDEvent) GTID(BinlogFormat) (replication.GTID, bool, error) {
	return ev.gtid, false, nil
}
