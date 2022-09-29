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
	"context"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
)

// Ensure that the Vindex properties are correctly defined upon creation
func TestSqliteLookupUniqueInfo(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t)
	assert.Equal(t, 5, sqliteLookupUnique.Cost())
	assert.Equal(t, "etsy_sqlite_lookup_unique", sqliteLookupUnique.String())
	assert.True(t, sqliteLookupUnique.IsUnique())
	assert.False(t, sqliteLookupUnique.NeedsVCursor())
}

// Ensure that the Vindex correctly maps ids to destinations
func TestSqliteLookupUniqueMap(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t)

	// Single id
	got, err := sqliteLookupUnique.Map(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(1)})
	require.NoError(t, err)
	want := []key.Destination{
		key.DestinationKeyspaceID([]byte("10")),
	}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("SqliteLookupUnique.Map(): %+v, want %+v", got, want)
	}

	// List of ids
	got, err = sqliteLookupUnique.Map(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(2), sqltypes.NewInt64(3), sqltypes.NewInt64(1)})
	require.NoError(t, err)
	want = []key.Destination{
		key.DestinationKeyspaceID([]byte("11")),
		key.DestinationNone{},
		key.DestinationKeyspaceID([]byte("10")),
	}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("SqliteLookupUnique.Map(): %+v, want %+v", got, want)
	}

	// List of ids with duplicate
	got, err = sqliteLookupUnique.Map(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(2), sqltypes.NewInt64(3), sqltypes.NewInt64(1), sqltypes.NewInt64(2)})
	require.NoError(t, err)
	want = []key.Destination{
		key.DestinationKeyspaceID([]byte("11")),
		key.DestinationNone{},
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationKeyspaceID([]byte("11")),
	}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("SqliteLookupUnique.Map(): %+v, want %+v", got, want)
	}
}

// Ensure that the Vindex correctly verifies results
func TestSqliteLookupUniqueVerify(t *testing.T) {
	sqlitelookupunique := createSqliteLookupUnique(t)

	// Single id
	got, err := sqlitelookupunique.Verify(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(2)}, [][]byte{[]byte("11")})
	require.NoError(t, err)
	want := []bool{true}
	assert.Equalf(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)

	// List of ids
	got, err = sqlitelookupunique.Verify(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(2), sqltypes.NewInt64(1), sqltypes.NewInt64(3)}, [][]byte{[]byte("invalid"), []byte("10"), []byte("dne")})
	require.NoError(t, err)
	want = []bool{false, true, false}
	assert.Equalf(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)

	// List of ids with duplicate
	got, err = sqlitelookupunique.Verify(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(2), sqltypes.NewInt64(1), sqltypes.NewInt64(3), sqltypes.NewInt64(1)}, [][]byte{[]byte("invalid"), []byte("10"), []byte("dne"), []byte("10")})
	require.NoError(t, err)
	want = []bool{false, true, false, true}
	assert.Equalf(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)
}

// Ensure that the Vindex cannot create lookup records
func TestSqliteLookupUniqueCreate(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t)

	err := sqliteLookupUnique.(Lookup).Create(context.Background(), nil, [][]sqltypes.Value{{sqltypes.NewInt64(3)}}, [][]byte{[]byte("12")}, false)
	want := "SqliteLookupUnique.Create: tried to create new lookup row in read-only SQLite database"
	if err == nil || err.Error() != want {
		t.Errorf("SqliteLookupUnique.Create in read only got error: %v, want %s", err, want)
	}
}

// Ensure that the Vindex cannot remove lookup records
func TestSqliteLookupUniqueDelete(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t)

	err := sqliteLookupUnique.(Lookup).Delete(context.Background(), nil, [][]sqltypes.Value{{sqltypes.NewInt64(3)}}, []byte("12"))
	want := "SqliteLookupUnique.Delete: tried to delete lookup row from read-only SQLite database"
	if err == nil || err.Error() != want {
		t.Errorf("SqliteLookupUnique.Delete in read only got error: %v, want %s", err, want)
	}
}

// Ensure that the Vindex cannot update lookup records
func TestSqliteLookupUniqueUpdate(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t)

	err := sqliteLookupUnique.(Lookup).Update(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(3)}, []byte("12"), []sqltypes.Value{sqltypes.NewInt64(1)})
	want := "SqliteLookupUnique.Update: tried to update lookup row in read-only SQLite database"
	if err == nil || err.Error() != want {
		t.Errorf("SqliteLookupUnique.Update in read only got error: %v, want %s", err, want)
	}
}

func createSqliteLookupUnique(t *testing.T) SingleColumn {
	t.Helper()
	l, err := CreateVindex("etsy_sqlite_lookup_unique", "etsy_sqlite_lookup_unique", map[string]string{
		"path":       "testdata/sqlite_vindex_test.db",
		"table":      "t",
		"from":       "id",
		"to":         "ksid",
		"cache_size": "100",
	})
	if err != nil {
		t.Fatal(err)
	}
	return l.(SingleColumn)
}
