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

package vindexes

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"

	_ "github.com/mattn/go-sqlite3" // sqlite driver
)

var (
	_ SingleColumn = (*SqliteLookupUnique)(nil)
	_ Lookup       = (*SqliteLookupUnique)(nil)
)

func init() {
	Register("etsy_sqlite_lookup_unique", NewSqliteLookupUnique)
}

// SqliteLookupUnique defines a vindex that uses a sqlite lookup table.
// The table is expected to define the id column as unique. It's
// Unique and a Lookup.
type SqliteLookupUnique struct {
	name           string
	db             *sql.DB
	table          string
	from           string
	to             string
	preparedSelect *sql.Stmt
}

// NewSqliteLookupUnique creates a SqliteLookupUnique vindex.
// The supplied map has the following required fields:
//   path: path to the backing sqlite file.
//   table: name of the backing table.
//   from: the column in the table that has the 'from' value of the lookup vindex.
//   to: the 'to' column name of the table that contains the keyrange or keyspace id.
//
//   As writes cannot be distributed across all vtgate machines, and writes must obtain
//   locks on the sqlite db, SQLite lookups are always read only
func NewSqliteLookupUnique(name string, m map[string]string) (Vindex, error) {
	slu := &SqliteLookupUnique{name: name}
	slu.table = m["table"]
	slu.from = m["from"]
	slu.to = m["to"]

	var err error
	// Options defined here: https://github.com/mattn/go-sqlite3#connection-string
	// TODO test cache=shared
	dbDSN := "file:" + m["path"] + "?mode=ro&_query_only=true&immutable=true"
	db, err := sql.Open("sqlite3", dbDSN)
	if err != nil {
		return nil, err
	}
	if db != nil {
		db.SetMaxOpenConns(0) // no maximum
		db.SetMaxIdleConns(100)
		db.SetConnMaxIdleTime(10 * time.Minute)
		db.SetConnMaxLifetime(time.Hour)
	}
	slu.db = db

	stmt, err := slu.db.Prepare(fmt.Sprintf("select %s, %s from %s where %s = ?", slu.from, slu.to, slu.table, slu.from))
	if err != nil {
		return nil, err
	}
	slu.preparedSelect = stmt

	return slu, nil
}

// String returns the name of the vindex.
func (slu *SqliteLookupUnique) String() string {
	return slu.name
}

// Cost returns the cost of this vindex as 5.
func (slu *SqliteLookupUnique) Cost() int {
	return 5
}

// IsUnique returns true since the Vindex is unique.
func (slu *SqliteLookupUnique) IsUnique() bool {
	return true
}

// NeedsVCursor returns false since the Vindex does not need to execute queries to VTTablet.
func (slu *SqliteLookupUnique) NeedsVCursor() bool {
	return false
}

// Map maps an id to a key.Destination object. Because this vindex is unique, each id maps to a
// KeyRange or a single KeyspaceID.
// This mapping is used to determine which shard contains a row. If the id is absent from the vindex
// lookup table, Map returns key.DestinationNone{}, which does not map to any shard.
func (slu *SqliteLookupUnique) Map(vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	// Query sqlite database and build result map
	resultMap, err := slu.retrieveIDKsidMap(ids)
	if err != nil {
		return nil, err
	}

	// Build output from result map
	out := make([]key.Destination, 0, len(ids))
	for _, id := range ids {
		if ksid, ok := resultMap[id.ToString()]; ok {
			out = append(out, key.DestinationKeyspaceID(ksid))
		} else {
			out = append(out, key.DestinationNone{})
		}
	}

	return out, err
}

// Verify returns true if ids maps to ksids.
func (slu *SqliteLookupUnique) Verify(vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	// Query sqlite database and build result map
	resultMap, err := slu.retrieveIDKsidMap(ids)
	if err != nil {
		return nil, err
	}

	// Build output from result map
	out := make([]bool, 0, len(ids))
	for i, id := range ids {
		if ksid, ok := resultMap[id.ToString()]; ok {
			out = append(out, bytes.Equal(ksid, ksids[i]))
		} else {
			out = append(out, ok)
		}
	}

	return out, err
}

func (slu *SqliteLookupUnique) retrieveIDKsidMap(ids []sqltypes.Value) (map[string][]byte, error) {
	// Query sqlite database
	var query string
	var results *sql.Rows
	var err error
	if len(ids) == 1 { // use prepared statement
		results, err = slu.preparedSelect.Query(ids[0].ToString())
		if err != nil {
			return nil, err
		}
	} else { // do not use prepared statement
		query = fmt.Sprintf("select %s, %s from %s where %s in (", slu.from, slu.to, slu.table, slu.from)
		for _, id := range ids {
			query += id.ToString() + ", "
		}
		query = strings.TrimSuffix(query, ", ")
		query += ")"
		results, err = slu.db.Query(query)
		if err != nil {
			return nil, err
		}
	}
	defer func() {
		err = results.Close()
	}()

	// Create map of id => ksid from results
	resultMap := make(map[string][]byte, len(ids))
	for results.Next() {
		var id string
		var ksid []byte
		err = results.Scan(&id, &ksid)
		if err != nil {
			return nil, err
		}
		resultMap[id] = ksid
	}
	if err = results.Err(); err != nil {
		return nil, err
	}

	return resultMap, err
}

// Create reserves the id by inserting it into the vindex table.
func (slu *SqliteLookupUnique) Create(vcursor VCursor, rowsColValues [][]sqltypes.Value, ksids [][]byte, ignoreMode bool) error {
	// Cannot create new lookups in a SqliteLookup, as the database is always
	// in read-only mode.
	return fmt.Errorf("SqliteLookupUnique.Create: tried to create new lookup row in read-only SQLite database")
}

// Delete deletes the entry from the vindex lookup table.
func (slu *SqliteLookupUnique) Delete(vcursor VCursor, rowsColValues [][]sqltypes.Value, ksid []byte) error {
	// Cannot create new lookups in a SqliteLookup, as the database is always
	// in read-only mode.
	return fmt.Errorf("SqliteLookupUnique.Delete: tried to delete lookup row from read-only SQLite database")
}

// Update updates the entry in the vindex lookup table.
func (slu *SqliteLookupUnique) Update(vcursor VCursor, oldValues []sqltypes.Value, ksid []byte, newValues []sqltypes.Value) error {
	// Cannot create new lookups in a SqliteLookup, as the database is always
	// in read-only mode.
	return fmt.Errorf("SqliteLookupUnique.Update: tried to update lookup row in read-only SQLite database")
}

// MarshalJSON returns a JSON representation of LookupUnique.
func (slu *SqliteLookupUnique) MarshalJSON() ([]byte, error) {
	return json.Marshal(slu)
}

// IsBackfilling implements the LookupBackfill interface
func (slu *SqliteLookupUnique) IsBackfilling() bool {
	return false
}
