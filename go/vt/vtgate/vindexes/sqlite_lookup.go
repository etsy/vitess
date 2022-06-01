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

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"

	_ "github.com/mattn/go-sqlite3" // sqlite driver
)

var (
	_ SingleColumn = (*LookupUnique)(nil)
	_ Lookup       = (*LookupUnique)(nil)
)

func init() {
	Register("sqlite_lookup_unique", NewSqliteLookupUnique)
}

// SqliteLookupUnique defines a vindex that uses a sqlite lookup table.
// The table is expected to define the id column as unique. It's
// Unique and a Lookup.
type SqliteLookupUnique struct {
	name        string
	db          *sql.DB
	readOnly    bool
	table       string
	from        string
	to          string
	ignoreNulls bool
}

// NewSqliteLookupUnique creates a SqliteLookupUnique vindex.
// The supplied map has the following required fields:
//   path: path to the backing sqlite file.
//   table: name of the backing table.
//   from: the column in the table that has the 'from' value of the lookup vindex.
//   to: the 'to' column name of the table that contains the keyrange or keyspace id.
//
// The following fields are optional:
//   read_only: in this mode, Create, Delete, and Update function calls will result in error.
func NewSqliteLookupUnique(name string, m map[string]string) (Vindex, error) {
	slu := &SqliteLookupUnique{name: name}
	slu.table = m["table"]
	slu.from = m["from"]
	slu.to = m["to"]

	var err error
	slu.readOnly, err = boolFromMap(m, "read_only")
	if err != nil {
		return nil, err
	}

	db, err := sql.Open("sqlite3", m["path"])
	if err != nil {
		return nil, err
	}
	if db != nil {
		db.SetMaxOpenConns(1)
		db.SetMaxIdleConns(1)
	}
	slu.db = db

	return slu, nil
}

// String returns the name of the vindex.
func (slu *SqliteLookupUnique) String() string {
	return slu.name
}

// Cost returns the cost of this vindex as 10.
func (slu *SqliteLookupUnique) Cost() int {
	return 10
}

// IsUnique returns true since the Vindex is unique.
func (slu *SqliteLookupUnique) IsUnique() bool {
	return true
}

// NeedsVCursor satisfies the Vindex interface.
func (slu *SqliteLookupUnique) NeedsVCursor() bool {
	return false
}

// Map maps an id to a key.Destination object. Because this vindex is unique, each id maps to a
// KeyRange or a single KeyspaceID.
// This mapping is used to determine which shard contains a row. If the id is absent from the vindex
// lookup table, Map returns key.DestinationNone{}, which does not map to any shard.
func (slu *SqliteLookupUnique) Map(vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	out := make([]key.Destination, 0, len(ids))
	query := fmt.Sprintf("select %s, %s from %s where %s in (%s)", slu.from, slu.to, slu.table, slu.from, strings.TrimSuffix(strings.Repeat("?, ", len(ids)), ", "))
	stmt, err := slu.db.Prepare(query)
	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	var args []interface{}
	for _, id := range ids {
		args = append(args, id.ToString())
	}
	results, err := stmt.Query(args...)
	if err != nil {
		return nil, err
	}
	defer results.Close()

	var from string
	var to []byte
	i := 0
	for results.Next() {
		err = results.Scan(&from, &to)
		if err != nil {
			return nil, err
		}
		// If id is absent from the vindex lookup table, map it to key.DestinationNone
		for args[i] != from {
			out = append(out, key.DestinationNone{})
			i++
		}
		out = append(out, key.DestinationKeyspaceID(to))
		i++
	}
	// If no results are found for a given input id, map it to key.DestinationNone
	for len(out) != len(args) {
		out = append(out, key.DestinationNone{})
	}
	return out, nil
}

// Verify returns true if ids maps to ksids.
func (slu *SqliteLookupUnique) Verify(vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	out := make([]bool, 0, len(ids))
	query := fmt.Sprintf("select %s, %s from %s where %s in (%s)", slu.from, slu.to, slu.table, slu.from, strings.TrimSuffix(strings.Repeat("?, ", len(ids)), ", "))
	var args []interface{}
	for _, id := range ids {
		args = append(args, id.ToString())
	}
	stmt, err := slu.db.Prepare(query)
	if err != nil {
		return nil, err
	}
	defer stmt.Close()
	results, err := stmt.Query(args...)
	if err != nil {
		return nil, err
	}
	defer results.Close()
	i := 0
	for results.Next() {
		var id string
		var ksid []byte
		err = results.Scan(&id, &ksid)
		if err != nil {
			return nil, err
		}
		// If no results are found for a given input id, map it to false
		for id != ids[i].ToString() {
			out = append(out, false)
			i++
		}
		out = append(out, bytes.Equal(ksid, ksids[i]))
		i++
	}
	// If no results are found for a given input id, map it to false
	for len(out) != len(args) {
		out = append(out, false)
	}
	return out, nil
}

// Create reserves the id by inserting it into the vindex table.
func (slu *SqliteLookupUnique) Create(vcursor VCursor, rowsColValues [][]sqltypes.Value, ksids [][]byte, ignoreMode bool) error {
	// Cannot create new lookups in read-only mode
	if slu.readOnly {
		return fmt.Errorf("SqliteLookupUnique.Create: tried to create new lookup row in read-only mode")
	}

	// Remove nulls (or throw if nulls are not allowed)
	trimmedFromValues := make([]string, 0, len(rowsColValues))
	trimmedToValues := make([][]byte, 0, len(ksids))
	for i, row := range rowsColValues {
		if row[0].IsNull() {
			if !slu.ignoreNulls {
				return fmt.Errorf("SqliteLookupUnique.Create: input has null values: row: %d, col: %d", row[0], ksids[i])
			}
			continue
		}
		if len(row) != 1 {
			return fmt.Errorf("SqliteLookupUnique.Create: column vindex count should be 1: got %d", len(trimmedFromValues[0]))
		}
		trimmedFromValues = append(trimmedFromValues, row[0].ToString())
		trimmedToValues = append(trimmedToValues, ksids[i])
	}
	if len(trimmedFromValues) == 0 {
		return nil
	}

	// Build query and params
	var query string
	if ignoreMode {
		query = fmt.Sprintf("insert or ignore into %s(", slu.table)
	} else {
		query = fmt.Sprintf("insert into %s(", slu.table)
	}
	query += fmt.Sprintf("%s, %s) values (", slu.from, slu.to)
	var args []interface{}
	for i, toVal := range trimmedToValues {
		fromVal := trimmedFromValues[i]
		if i != 0 {
			query += ", ("
		}
		query += "?,?)"
		args = append(args, fromVal, toVal)
	}
	stmt, err := slu.db.Prepare(query)
	if err != nil {
		return err
	}
	defer stmt.Close()
	_, err = stmt.Exec(args...)
	if err != nil {
		return err
	}
	return nil
}

// Delete deletes the entry from the vindex lookup table.
func (slu *SqliteLookupUnique) Delete(vcursor VCursor, rowsColValues [][]sqltypes.Value, ksid []byte) error {
	// Cannot update lookups in read-only mode
	if slu.readOnly {
		return fmt.Errorf("SqliteLookupUnique.Delete: tried to delete lookup row in read-only mode")
	}

	if len(rowsColValues) != 1 {
		return fmt.Errorf("SqliteLookupUnique.Delete: column vindex count should be 1: got %d", len(rowsColValues))
	}

	valid, err := slu.Verify(vcursor, rowsColValues[0], [][]byte{ksid})
	if err != nil {
		return err
	}
	if !valid[0] {
		return nil
	}

	query := fmt.Sprintf("delete from %s where %s = ?", slu.table, slu.from)
	stmt, err := slu.db.Prepare(query)
	if err != nil {
		return err
	}
	defer stmt.Close()
	_, err = stmt.Exec(rowsColValues[0][0].ToString())
	if err != nil {
		return err
	}
	return nil
}

// Update updates the entry in the vindex lookup table.
func (slu *SqliteLookupUnique) Update(vcursor VCursor, oldValues []sqltypes.Value, ksid []byte, newValues []sqltypes.Value) error {
	// Cannot update lookups in read-only mode
	if slu.readOnly {
		return fmt.Errorf("SqliteLookupUnique.Update: tried to update lookup row in read-only mode")
	}

	if err := slu.Delete(vcursor, [][]sqltypes.Value{oldValues}, ksid); err != nil {
		return err
	}
	return slu.Create(vcursor, [][]sqltypes.Value{newValues}, [][]byte{ksid}, false /* ignoreMode */)
}

// MarshalJSON returns a JSON representation of LookupUnique.
func (slu *SqliteLookupUnique) MarshalJSON() ([]byte, error) {
	return json.Marshal(slu)
}

// IsBackfilling implements the LookupBackfill interface
func (slu *SqliteLookupUnique) IsBackfilling() bool {
	return !slu.readOnly
}
