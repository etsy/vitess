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
	"os"
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
)

// Ensure that the Vindex properties are correctly defined upon creation
func TestSqliteLookupUniqueNew(t *testing.T) {
	vindex, _ := CreateVindex("sqlite_lookup_unique", "sqlite_lookup_unique", map[string]string{
		"driver":    "sqlite3",
		"path":      "path/to/db",
		"table":     "t",
		"from":      "from_col",
		"to":        "to_col",
		"read_only": "true",
	})
	l := vindex.(SingleColumn)
	if want, got := l.(*SqliteLookupUnique).readOnly, true; got != want {
		t.Errorf("Create(sqlite_lookup_unique, false): %v, want %v", got, want)
	}

	_, err := CreateVindex("sqlite_lookup_unique", "sqlite_lookup_unique", map[string]string{
		"driver":    "sqlite3",
		"path":      "path/to/db",
		"table":     "t",
		"from":      "from_col",
		"to":        "to_col",
		"read_only": "invalid",
	})
	want := "read_only value must be 'true' or 'false': 'invalid'"
	if err == nil || err.Error() != want {
		t.Errorf("Create(bad_sqlite_lookup_unique): %v, want %s", err, want)
	}
}

// Ensure that the Vindex properties are correctly defined upon creation
func TestSqliteLookupUniqueInfo(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false, "path/to/db")
	assert.Equal(t, 10, sqliteLookupUnique.Cost())
	assert.Equal(t, "sqlite_lookup_unique", sqliteLookupUnique.String())
	assert.True(t, sqliteLookupUnique.IsUnique())
	assert.False(t, sqliteLookupUnique.NeedsVCursor())
}

// Ensure that the Vindex correctly maps ids to destinations
func TestSqliteLookupUniqueMap(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false, "testdata/sqlite_vindex_test.db")

	got, err := sqliteLookupUnique.Map(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(2), sqltypes.NewInt64(3)})
	require.NoError(t, err)
	want := []key.Destination{
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationKeyspaceID([]byte("11")),
		key.DestinationNone{},
	}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("SqliteLookupUnique.Map(): %+v, want %+v", got, want)
	}

}

// Ensure that the Vindex correctly maps ids to destinations in read only mode
func TestSqliteLookupUniqueMapReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true, "testdata/sqlite_vindex_test.db")

	got, err := sqliteLookupUnique.Map(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(3), sqltypes.NewInt64(2)})
	require.NoError(t, err)
	want := []key.Destination{
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationNone{},
		key.DestinationKeyspaceID([]byte("11")),
	}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("SqliteLookupUnique.Map(): %+v, want %+v", got, want)
	}

}

// Ensure that the Vindex correctly verifies results
func TestSqliteLookupUniqueVerify(t *testing.T) {
	sqlitelookupunique := createSqliteLookupUnique(t, false, "testdata/sqlite_vindex_test.db")

	got, err := sqlitelookupunique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(2)}, [][]byte{[]byte("10"), []byte("invalid")})
	require.NoError(t, err)
	want := []bool{true, false}
	assert.Equalf(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)
}

// Ensure that the Vindex correctly verifies results in read only mode
func TestSqliteLookupUniqueVerifyReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true, "testdata/sqlite_vindex_test.db")

	got, err := sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(2)}, [][]byte{[]byte("invalid"), []byte("11")})
	require.NoError(t, err)
	want := []bool{false, true}
	assert.Equalf(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)
}

// Ensure that the Vindex correctly creates lookup records (in a temporary table)
func TestSqliteLookupUniqueCreate(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false, "testdata/temp.db")
	defer os.Remove("testdata/temp.db")
	_, err := sqliteLookupUnique.(*SqliteLookupUnique).db.Exec("create table t(id text primary key, ksid blob);")
	require.NoError(t, err)

	err = sqliteLookupUnique.(Lookup).Create(nil, [][]sqltypes.Value{{sqltypes.NewInt64(3)}}, [][]byte{[]byte("12")}, false)
	require.NoError(t, err)

	got, err := sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(3)}, [][]byte{[]byte("12")})
	require.NoError(t, err)
	want := []bool{true}
	assert.Equalf(t, want, got, "SqliteLookupUnique.Create(): %+v, want %+v", got, want)
}

// Ensure that the Vindex cannot create lookup records in read only mode
func TestSqliteLookupUniqueCreateReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true, "testdata/temp.db")
	defer os.Remove("testdata/temp.db")

	err := sqliteLookupUnique.(Lookup).Create(nil, [][]sqltypes.Value{{sqltypes.NewInt64(3)}}, [][]byte{[]byte("12")}, false)
	want := "SqliteLookupUnique.Create: tried to create new lookup row in read-only mode"
	if err == nil || err.Error() != want {
		t.Errorf("SqliteLookupUnique.Create in read only got error: %v, want %s", err, want)
	}
}

// Ensure that the Vindex correctly removes lookup records (from a temporary table)
func TestSqliteLookupUniqueDelete(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false, "testdata/temp.db")
	defer os.Remove("testdata/temp.db")
	_, err := sqliteLookupUnique.(*SqliteLookupUnique).db.Exec("create table t(id text primary key, ksid blob);")
	require.NoError(t, err)

	err = sqliteLookupUnique.(Lookup).Create(nil, [][]sqltypes.Value{{sqltypes.NewInt64(1)}}, [][]byte{[]byte("test")}, true)
	require.NoError(t, err)
	got, err := sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1)}, [][]byte{[]byte("test")})
	require.NoError(t, err)
	assert.True(t, got[0], "Could not create row to delete")

	err = sqliteLookupUnique.(Lookup).Delete(nil, [][]sqltypes.Value{{sqltypes.NewInt64(1)}}, []byte("incorrect"))
	require.NoError(t, err)
	got, err = sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1)}, [][]byte{[]byte("test")})
	require.NoError(t, err)
	assert.True(t, got[0], "SqliteLookupUnique.Delete: lookup row deleted incorrectly")

	err = sqliteLookupUnique.(Lookup).Delete(nil, [][]sqltypes.Value{{sqltypes.NewInt64(1)}}, []byte("test"))
	require.NoError(t, err)
	got, err = sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1)}, [][]byte{[]byte("test")})
	require.NoError(t, err)
	assert.False(t, got[0], "SqliteLookupUnique.Delete: lookup row was not deleted")
}

// Ensure that the Vindex cannot remove lookup records in read only mode
func TestSqliteLookupUniqueDeleteReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true, "testdata/temp.db")
	defer os.Remove("testdata/temp.db")

	err := sqliteLookupUnique.(Lookup).Delete(nil, [][]sqltypes.Value{{sqltypes.NewInt64(3)}}, []byte("12"))
	want := "SqliteLookupUnique.Delete: tried to delete lookup row in read-only mode"
	if err == nil || err.Error() != want {
		t.Errorf("SqliteLookupUnique.Delete in read only got error: %v, want %s", err, want)
	}
}

// Ensure that the Vindex correctly updates lookup records (in a temporary table)
func TestSqliteLookupUniqueUpdate(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false, "testdata/temp.db")
	defer os.Remove("testdata/temp.db")
	_, err := sqliteLookupUnique.(*SqliteLookupUnique).db.Exec("create table t(id text primary key, ksid blob);")
	require.NoError(t, err)

	err = sqliteLookupUnique.(Lookup).Create(nil, [][]sqltypes.Value{{sqltypes.NewInt64(1)}}, [][]byte{[]byte("test")}, true)
	require.NoError(t, err)
	got, err := sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1)}, [][]byte{[]byte("test")})
	require.NoError(t, err)
	assert.True(t, got[0], "Could not create row to update")

	err = sqliteLookupUnique.(Lookup).Update(nil, []sqltypes.Value{sqltypes.NewInt64(1)}, []byte("test"), []sqltypes.Value{sqltypes.NewInt64(2)})
	require.NoError(t, err)
	got, err = sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(2)}, [][]byte{[]byte("test"), []byte("test")})
	require.NoError(t, err)
	want := []bool{false, true}
	assert.Equal(t, want, got, "SqliteLookupUnique.Update: lookup row was not updated")
}

// Ensure that the Vindex cannot update lookup records in read only mode
func TestSqliteLookupUniqueUpdateReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true, "testdata/temp.db")
	defer os.Remove("testdata/temp.db")

	err := sqliteLookupUnique.(Lookup).Update(nil, []sqltypes.Value{sqltypes.NewInt64(3)}, []byte("12"), []sqltypes.Value{sqltypes.NewInt64(1)})
	want := "SqliteLookupUnique.Update: tried to update lookup row in read-only mode"
	if err == nil || err.Error() != want {
		t.Errorf("SqliteLookupUnique.Update in read only got error: %v, want %s", err, want)
	}
}

func createSqliteLookupUnique(t *testing.T, readOnly bool, path string) SingleColumn {
	t.Helper()
	read := "false"
	if readOnly {
		read = "true"
	}
	l, err := CreateVindex("sqlite_lookup_unique", "sqlite_lookup_unique", map[string]string{
		"driver":    "sqlite3",
		"path":      path,
		"table":     "t",
		"from":      "id",
		"to":        "ksid",
		"read_only": read,
	})
	if err != nil {
		t.Fatal(err)
	}
	return l.(SingleColumn)
}
