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
	hybridHashReverseThreshold := createHybridWithThreshold("hash", "reverse_bits", 5, map[string]string{}, t)
	assert.Equal(t, 1, hybridHashReverseThreshold.Cost())
	assert.Equal(t, "etsy_hybrid", hybridHashReverseThreshold.String())
	assert.True(t, hybridHashReverseThreshold.IsUnique())
	assert.Equal(t, "etsy_hybrid_a_hash", hybridHashReverseThreshold.(*Hybrid).vindexA.String())
	assert.Equal(t, "etsy_hybrid_b_reverse_bits", hybridHashReverseThreshold.(*Hybrid).vindexB.String())
	assert.Equal(t, uint64(5), hybridHashReverseThreshold.(*Hybrid).threshold)
	assert.Equal(t, map[string]SingleColumn{"etsy_hybrid": hybridHashReverseThreshold}, hybridVindexes)

	hybridHashReverseFallback := createHybridWithFallback("hash", "reverse_bits", map[string]string{}, t)
	assert.Equal(t, 1, hybridHashReverseFallback.Cost())
	assert.Equal(t, "etsy_hybrid", hybridHashReverseFallback.String())
	assert.True(t, hybridHashReverseFallback.IsUnique())
	assert.Equal(t, "etsy_hybrid_a_hash", hybridHashReverseFallback.(*Hybrid).vindexA.String())
	assert.Equal(t, "etsy_hybrid_b_reverse_bits", hybridHashReverseFallback.(*Hybrid).vindexB.String())
	assert.Equal(t, uint64(0), hybridHashReverseFallback.(*Hybrid).threshold)

	hybridSqliteHashThreshold := createHybridWithThreshold("etsy_sqlite_lookup_unique", "hash", 5, map[string]string{
		"path":  "testdata/sqlite_vindex_test.db",
		"table": "t",
		"from":  "id",
		"to":    "ksid",
	}, t)
	assert.Equal(t, 5, hybridSqliteHashThreshold.Cost())
	assert.Equal(t, "etsy_hybrid", hybridSqliteHashThreshold.String())
	assert.True(t, hybridSqliteHashThreshold.IsUnique())
	assert.Equal(t, "etsy_hybrid_a_etsy_sqlite_lookup_unique", hybridSqliteHashThreshold.(*Hybrid).vindexA.String())
	assert.Equal(t, "etsy_hybrid_b_hash", hybridSqliteHashThreshold.(*Hybrid).vindexB.String())
	assert.Equal(t, uint64(5), hybridSqliteHashThreshold.(*Hybrid).threshold)

	hybridSqliteHashFallback := createHybridWithFallback("etsy_sqlite_lookup_unique", "hash", map[string]string{
		"path":  "testdata/sqlite_vindex_test.db",
		"table": "t",
		"from":  "id",
		"to":    "ksid",
	}, t)
	assert.Equal(t, 5, hybridSqliteHashFallback.Cost())
	assert.Equal(t, "etsy_hybrid", hybridSqliteHashFallback.String())
	assert.True(t, hybridSqliteHashFallback.IsUnique())
	assert.Equal(t, "etsy_hybrid_a_etsy_sqlite_lookup_unique", hybridSqliteHashFallback.(*Hybrid).vindexA.String())
	assert.Equal(t, "etsy_hybrid_b_hash", hybridSqliteHashFallback.(*Hybrid).vindexB.String())
	assert.Equal(t, uint64(0), hybridSqliteHashFallback.(*Hybrid).threshold)
	assert.Equal(t, map[string]SingleColumn{"etsy_hybrid": hybridSqliteHashFallback}, hybridVindexes)
}

// Ensure that the Vindex correctly maps ids to destinations
func TestHybridMapWithThreshold(t *testing.T) {
	hybridSqliteHash := createHybridWithThreshold("etsy_sqlite_lookup_unique", "hash", 5, map[string]string{
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

// Ensure that the Vindex correctly maps ids to destinations when no threshold is provided
func TestHybridMapWithFallback(t *testing.T) {
	hybridSqliteHash := createHybridWithFallback("etsy_sqlite_lookup_unique", "hash", map[string]string{
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
		sqltypes.NewInt64(500),
		sqltypes.NewVarBinary("500"),
	})
	require.NoError(t, err)
	want := []key.Destination{
		key.DestinationKeyspaceID([]byte("N\xb1\x90\xc9\xa2\xfa\x16\x9c")),
		key.DestinationKeyspaceID([]byte("N\xb1\x90\xc9\xa2\xfa\x16\x9c")),
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationKeyspaceID([]byte("10")),
		key.DestinationKeyspaceID([]byte("17")),
		key.DestinationKeyspaceID([]byte("17")),
		key.DestinationKeyspaceID([]byte("\xad\xa4\xf0\xa6;S\x99\x13")),
		key.DestinationKeyspaceID([]byte("\xad\xa4\xf0\xa6;S\x99\x13")),
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
func TestHybridVerifyWithThreshold(t *testing.T) {
	hybridSqliteHash := createHybridWithThreshold("etsy_sqlite_lookup_unique", "hash", 5, map[string]string{
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

// Ensure that the Vindex correctly verifies results
func TestHybridVerifyNoThreshold(t *testing.T) {
	hybridSqliteHash := createHybridWithFallback("etsy_sqlite_lookup_unique", "hash", map[string]string{
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

func createHybridWithThreshold(vindexA string, vindexB string, threshold int, options map[string]string, t *testing.T) SingleColumn {
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

func createHybridWithFallback(vindexA string, vindexB string, options map[string]string, t *testing.T) SingleColumn {
	t.Helper()
	options["vindex_a"] = vindexA
	options["vindex_b"] = vindexB

	l, err := CreateVindex("etsy_hybrid", "etsy_hybrid", options)
	if err != nil {
		t.Fatal(err)
	}
	return l.(SingleColumn)
}
