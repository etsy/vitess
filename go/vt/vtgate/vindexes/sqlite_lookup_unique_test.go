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
	"reflect"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
)

func TestSqliteLookupUniqueNew(t *testing.T) {
	vindex, _ := CreateVindex("sqlite_lookup_unique", "sqlite_lookup_unique", map[string]string{
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

func TestSqliteLookupUniqueInfo(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false)
	assert.Equal(t, 10, sqliteLookupUnique.Cost())
	assert.Equal(t, "sqlite_lookup_unique", sqliteLookupUnique.String())
	assert.True(t, sqliteLookupUnique.IsUnique())
	assert.False(t, sqliteLookupUnique.NeedsVCursor())
}

func TestSqliteLookupUniqueMap(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, false)

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

func TestSqliteLookupUniqueMapReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true)

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

func TestSqliteLookupUniqueVerify(t *testing.T) {
	sqlitelookupunique := createSqliteLookupUnique(t, false)

	got, err := sqlitelookupunique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(2)}, [][]byte{[]byte("10"), []byte("invalid")})
	require.NoError(t, err)
	want := []bool{true, false}
	assert.Equal(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)
}

func TestSqliteLookupUniqueVerifyReadOnly(t *testing.T) {
	sqliteLookupUnique := createSqliteLookupUnique(t, true)

	got, err := sqliteLookupUnique.Verify(nil, []sqltypes.Value{sqltypes.NewInt64(1), sqltypes.NewInt64(2)}, [][]byte{[]byte("invalid"), []byte("11")})
	require.NoError(t, err)
	want := []bool{false, true}
	assert.Equal(t, want, got, "SqliteLookupUnique.Verify(): %+v, want %+v", got, want)
}

func createSqliteLookupUnique(t *testing.T, readOnly bool) SingleColumn {
	t.Helper()
	read := "false"
	if readOnly {
		read = "true"
	}
	l, err := CreateVindex("sqlite_lookup_unique", "sqlite_lookup_unique", map[string]string{
		"path":      "testdata/sqlite_vindex_test.db",
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
