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
	"strconv"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
)

// Ensure that the Vindex properties are correctly defined upon creation
func TestHybridInfo(t *testing.T) {
	hybridHashReverse := createHybrid("hash", "reverse_bits", 5, map[string]string{}, t)
	assert.Equal(t, 1, hybridHashReverse.Cost())
	assert.Equal(t, "etsy_hybrid", hybridHashReverse.String())
	assert.True(t, hybridHashReverse.IsUnique())
	assert.Equal(t, "etsy_hybrid_a_hash", hybridHashReverse.(*Hybrid).vindexA.String())
	assert.Equal(t, "etsy_hybrid_b_reverse_bits", hybridHashReverse.(*Hybrid).vindexB.String())
	assert.Equal(t, uint64(5), hybridHashReverse.(*Hybrid).threshold)

	hybridSqliteHash := createHybrid("etsy_sqlite_lookup_unique", "hash", 5, map[string]string{
		"path":  "testdata/sqlite_vindex_test.db",
		"table": "t",
		"from":  "id",
		"to":    "ksid",
	}, t)
	assert.Equal(t, 5, hybridSqliteHash.Cost())
	assert.Equal(t, "etsy_hybrid", hybridSqliteHash.String())
	assert.True(t, hybridSqliteHash.IsUnique())
	assert.Equal(t, "etsy_hybrid_a_etsy_sqlite_lookup_unique", hybridSqliteHash.(*Hybrid).vindexA.String())
	assert.Equal(t, "etsy_hybrid_b_hash", hybridSqliteHash.(*Hybrid).vindexB.String())
	assert.Equal(t, uint64(5), hybridHashReverse.(*Hybrid).threshold)
}

// Ensure that the Vindex correctly maps ids to destinations
func TestHybridMap(t *testing.T) {
	hybridSqliteHash := createHybrid("etsy_sqlite_lookup_unique", "hash", 5, map[string]string{
		"path":  "testdata/sqlite_vindex_test.db",
		"table": "t",
		"from":  "id",
		"to":    "ksid",
	}, t)

	// List of ids
	got, err := hybridSqliteHash.Map(context.Background(), nil, []sqltypes.Value{
		sqltypes.NewInt64(3),
		sqltypes.NewVarChar("3"),
		sqltypes.NewInt64(1),
		sqltypes.NewVarBinary("1"),
		sqltypes.NewInt64(6),
		sqltypes.NewVarBinary("6"),
	})
	require.NoError(t, err)
	want := []key.Destination{
		key.DestinationNone{},
		key.DestinationNone{},
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationKeyspaceID([]byte("\xf0\x98H\n\xc4ľq")),
		key.DestinationKeyspaceID([]byte("\xf0\x98H\n\xc4ľq")),
	}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("Hybrid.Map(): %+v, want %+v", got, want)
	}

	// Test that negative ids fail to map to a ksid
	_, err = hybridSqliteHash.Map(context.Background(), nil, []sqltypes.Value{
		sqltypes.NewInt64(-13),
	})
	require.Error(t, err)

	_, err = hybridSqliteHash.Map(context.Background(), nil, []sqltypes.Value{
		sqltypes.NewVarBinary("-13"),
	})
	require.Error(t, err)
}

// Ensure that the Vindex correctly verifies results
func TestHybridVerify(t *testing.T) {
	hybridSqliteHash := createHybrid("etsy_sqlite_lookup_unique", "hash", 5, map[string]string{
		"path":  "testdata/sqlite_vindex_test.db",
		"table": "t",
		"from":  "id",
		"to":    "ksid",
	}, t)

	// List of ids
	got, err := hybridSqliteHash.Verify(context.Background(), nil, []sqltypes.Value{sqltypes.NewInt64(2), sqltypes.NewInt64(1), sqltypes.NewInt64(5), sqltypes.NewInt64(6)}, [][]byte{[]byte("incorrect"), []byte("10"), []byte("dne"), []byte("\xf0\x98H\n\xc4ľq")})
	require.NoError(t, err)
	want := []bool{false, true, false, true}
	assert.Equalf(t, want, got, "Hybrid.Verify(): %+v, want %+v", got, want)
}

func createHybrid(vindexA string, vindexB string, threshold int, options map[string]string, t *testing.T) SingleColumn {
	t.Helper()
	options["vindex_a"] = vindexA
	options["vindex_b"] = vindexB
	options["threshold"] = strconv.Itoa(threshold)

	l, err := CreateVindex("etsy_hybrid", "etsy_hybrid", options)
	if err != nil {
		t.Fatal(err)
	}
	return l.(SingleColumn)
}
