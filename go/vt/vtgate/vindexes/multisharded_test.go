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
	"context"
	"strconv"
	"testing"

	"github.com/google/go-cmp/cmp"
	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
	vschemapb "vitess.io/vitess/go/vt/proto/vschema"
)

func init() {
	Register("singlecol_stub", NewSinglecolStub)
}

// Ensure that MultiSharded properties are correctly defined upon creation
func TestMultiShardedCreation(t *testing.T) {
	expectedName := "multisharded_test"
	expectedParams := map[string]string{
		"type_id_to_vindex": `{"1":"subvindex_1", "2":"subvindex_2"}`,
	}

	subvindex1Params := map[string]string{
		"param1": "a",
		"param2": "b",
		"param3": "c",
	}

	subvindex2Params := map[string]string{
		"param1": "x",
		"param2": "y",
		"param3": "z",
	}

	vindexSchemaStub := map[string]*vschemapb.Vindex{
		"subvindex_1": &vschemapb.Vindex{
			Type:   "singlecol_stub",
			Params: subvindex1Params,
			Owner:  "",
		},
		"subvindex_2": &vschemapb.Vindex{
			Type:   "singlecol_stub",
			Params: subvindex2Params,
			Owner:  "",
		},
		"multisharded_test": &vschemapb.Vindex{
			Type:   "etsy_multisharded_hybrid",
			Params: expectedParams,
			Owner:  "",
		},
	}

	multisharded, err := CreateVindex("etsy_multisharded_hybrid", expectedName, expectedParams, vindexSchemaStub)
	if err != nil {
		t.Fatal(err)
	}

	actualName := multisharded.String()
	if actualName != expectedName {
		t.Errorf(
			"Got unexpected value for multisharded.String(). Expected: %v, Got: %v",
			expectedName,
			actualName)
	}

	expectedTypeIdToSubvindexName := map[string]string{"1": "multisharded_test_subvindex_1", "2": "multisharded_test_subvindex_2"}
	diff := cmp.Diff(multisharded.(*MultiSharded).typeIdToSubvindexName,
		expectedTypeIdToSubvindexName,
		cmp.AllowUnexported(SinglecolStub{}))

	if diff != "" {
		t.Errorf(
			"Got unexpected value for multisharded.TypeIdToVindexName. Expected: %v, Got: %v",
			expectedTypeIdToSubvindexName,
			multisharded.(*MultiSharded).typeIdToSubvindexName)
	}

	expectedSubvindex1, err := CreateVindex("singlecol_stub", "multisharded_test_subvindex_1", subvindex1Params, vindexSchemaStub)
	if err != nil {
		t.Fatal(err)
	}

	expectedSubvindex2, err := CreateVindex("singlecol_stub", "multisharded_test_subvindex_2", subvindex2Params, vindexSchemaStub)
	if err != nil {
		t.Fatal(err)
	}

	expectedSubvindexMap := map[string]SingleColumn{
		"multisharded_test_subvindex_1": expectedSubvindex1.(SingleColumn),
		"multisharded_test_subvindex_2": expectedSubvindex2.(SingleColumn),
	}

	diff = cmp.Diff(multisharded.(*MultiSharded).createdSubvindexes,
		expectedSubvindexMap, cmp.AllowUnexported(SinglecolStub{}))

	if diff != "" {
		t.Errorf(
			"Got unexpected value for multisharded.createdSubvindexes. Expected: %v, Got: %v",
			expectedSubvindexMap,
			multisharded.(*MultiSharded).createdSubvindexes)
	}
}

func TestMultiShardedCreationWithNonexistantSubvindex(t *testing.T) {
	params := map[string]string{
		"type_id_to_vindex": `{"1":"does_not_exist_1"}`,
	}

	vindexSchemaStub := map[string]*vschemapb.Vindex{
		"subvindex_1": &vschemapb.Vindex{
			Type:   "singlecol_stub",
			Params: map[string]string{},
			Owner:  "",
		},
		"subvindex_2": &vschemapb.Vindex{
			Type:   "singlecol_stub",
			Params: map[string]string{},
			Owner:  "",
		},
		"multisharded_test": &vschemapb.Vindex{
			Type:   "etsy_multisharded_hybrid",
			Params: params,
			Owner:  "",
		},
	}

	_, err := CreateVindex(
		"etsy_multisharded_hybrid",
		"multisharded_test",
		params,
		vindexSchemaStub)
	if err == nil {
		t.Errorf("Expected error from multisharded.NewMultiSharded, got nil")
	}
}

func TestMultiShardedMap(t *testing.T) {
	cases := []struct {
		name          string
		rowsColValues [][]sqltypes.Value
		expected      []key.Destination
		shouldErr     bool
	}{
		{
			"All rows map to same subvindex",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(5)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(7)},
			},
			[]key.Destination{
				key.DestinationKeyspaceID([]byte("10")),
				key.DestinationKeyspaceID([]byte("20")),
				key.DestinationNone{},
			},
			false,
		},
		{
			"Rows map to different subvindexes",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(60)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(70)},
			},
			[]key.Destination{
				key.DestinationKeyspaceID([]byte("10")),
				key.DestinationKeyspaceID([]byte("200")),
				key.DestinationNone{},
			},
			false,
		},
		{
			"Some rows map to subvindexes",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(60)},
				{sqltypes.NewInt64(500), sqltypes.NewInt64(70)},
			},
			nil,
			true,
		},
		{
			"No rows map to subvindexes",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(100), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(200), sqltypes.NewInt64(60)},
				{sqltypes.NewInt64(500), sqltypes.NewInt64(70)},
			},
			nil,
			true,
		},
		{
			"Errors when type_id is negative int",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(-1), sqltypes.NewInt64(100)},
			},
			nil,
			true,
		},
		{
			"Errors when id is negative int",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(-100)},
			},
			nil,
			true,
		},
		{
			"Errors when type_id is negative string",
			[][]sqltypes.Value{
				{sqltypes.NewVarChar("-1"), sqltypes.NewVarChar("100")},
			},
			nil,
			true,
		},
		{
			"Errors when id is negative string",
			[][]sqltypes.Value{
				{sqltypes.NewVarChar("1"), sqltypes.NewVarChar("-100")},
			},
			nil,
			true,
		},
		{
			"String ids supported",
			[][]sqltypes.Value{
				{sqltypes.NewVarChar("1"), sqltypes.NewVarChar("1")},
				{sqltypes.NewVarBinary("2"), sqltypes.NewVarBinary("60")},
			},
			[]key.Destination{
				key.DestinationKeyspaceID([]byte("10")),
				key.DestinationKeyspaceID([]byte("200")),
			},
			false,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			multisharded, err := CreateVindex(
				"etsy_multisharded_hybrid",
				"multisharded_test",
				map[string]string{"type_id_to_vindex": `{"1":"subvindex_a", "2":"subvindex_b"}`},
				map[string]*vschemapb.Vindex{
					"subvindex_a": &vschemapb.Vindex{
						Type:   "singlecol_stub",
						Params: map[string]string{},
						Owner:  "",
					},
					"subvindex_b": &vschemapb.Vindex{
						Type:   "singlecol_stub",
						Params: map[string]string{},
						Owner:  "",
					},
					"multisharded_test": &vschemapb.Vindex{
						Type:   "etsy_multisharded_hybrid",
						Params: map[string]string{"type_id_to_vindex": ""},
						Owner:  "",
					},
				})

			if err != nil {
				t.Fatal(err)
			}

			actual, err := multisharded.(*MultiSharded).Map(context.Background(), nil, c.rowsColValues)
			if !c.shouldErr {
				if err != nil {
					t.Fatal(err)
				}

				diff := cmp.Diff(actual, c.expected)
				if diff != "" {
					t.Errorf("Got unexpected result from multisharded.Map. Expected: %v. Actual: %v.", c.expected, actual)
				}
			} else {
				if err == nil {
					t.Errorf("Expected error from multisharded.Map, got nil")
				}
			}

		})
	}
}

func TestMultiShardedVerify(t *testing.T) {
	cases := []struct {
		name          string
		rowsColValues [][]sqltypes.Value
		ksids         [][]byte
		expected      []bool
		shouldErr     bool
	}{
		{
			"Same subvindex, all ksids map correctly to ids",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(5)},
			},
			[][]byte{
				[]byte("20"),
				[]byte("10"),
				[]byte("200"),
			},
			[]bool{true, true, true},
			false,
		},
		{
			"Same subvindex, some incorrect ksids",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(5)},
			},
			[][]byte{
				[]byte("20"),
				[]byte("1000"),
				[]byte("10"),
			},
			[]bool{true, false, false},
			false,
		},
		{
			"Different subvindexes, all ksids map correctly to ids",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(30)},
			},
			[][]byte{
				[]byte("20"),
				[]byte("10"),
				[]byte("30"),
			},
			[]bool{true, true, true},
			false,
		},
		{
			"Different subvindexes, some incorrect ksids",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(30)},
			},
			[][]byte{
				[]byte("20"),
				[]byte("1000"),
				[]byte("3000"),
			},
			[]bool{true, false, false},
			false,
		},
		{
			"Different subvindexes, no correct ksids",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(30)},
				{sqltypes.NewInt64(2), sqltypes.NewInt64(10000)},
			},
			[][]byte{
				[]byte("2000"),
				[]byte("1000"),
				[]byte("3000"),
				[]byte("4000"),
			},
			[]bool{false, false, false, false},
			false,
		},
		{
			"Some rows map to subvindexes",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(1), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(200), sqltypes.NewInt64(5)},
			},
			[][]byte{
				[]byte("20"),
				[]byte("10"),
				[]byte("200"),
			},
			nil,
			true,
		},
		{
			"No rows map to subvindexes",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(100), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(200), sqltypes.NewInt64(2)},
				{sqltypes.NewInt64(300), sqltypes.NewInt64(5)},
			},
			[][]byte{
				[]byte("20"),
				[]byte("10"),
				[]byte("200"),
			},
			nil,
			true,
		},
		{
			"Errors when type_id is negative int",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(-1), sqltypes.NewInt64(1)},
			},
			[][]byte{
				[]byte("20"),
			},
			nil,
			true,
		},
		{
			"Errors when id is negative int",
			[][]sqltypes.Value{
				{sqltypes.NewInt64(1), sqltypes.NewInt64(-1)},
			},
			[][]byte{
				[]byte("20"),
			},
			nil,
			true,
		},
		{
			"Errors when type_id is negative string",
			[][]sqltypes.Value{
				{sqltypes.NewVarChar("-1"), sqltypes.NewVarChar("1")},
			},
			[][]byte{
				[]byte("20"),
			},
			nil,
			true,
		},
		{
			"Errors when id is negative string",
			[][]sqltypes.Value{
				{sqltypes.NewVarChar("1"), sqltypes.NewVarChar("-1")},
			},
			[][]byte{
				[]byte("20"),
			},
			nil,
			true,
		},
		{
			"String ids supported",
			[][]sqltypes.Value{
				{sqltypes.NewVarChar("1"), sqltypes.NewVarChar("1")},
				{sqltypes.NewVarBinary("1"), sqltypes.NewVarBinary("2")},
			},
			[][]byte{
				[]byte("20"),
				[]byte("10"),
			},
			[]bool{true, true},
			false,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			multisharded, err := CreateVindex(
				"etsy_multisharded_hybrid",
				"multisharded_test",
				map[string]string{"type_id_to_vindex": `{"1":"subvindex_a", "2":"subvindex_b"}`},
				map[string]*vschemapb.Vindex{
					"subvindex_a": &vschemapb.Vindex{
						Type:   "singlecol_stub",
						Params: map[string]string{},
						Owner:  "",
					},
					"subvindex_b": &vschemapb.Vindex{
						Type:   "singlecol_stub",
						Params: map[string]string{},
						Owner:  "",
					},
					"multisharded_test": &vschemapb.Vindex{
						Type:   "etsy_multisharded_hybrid",
						Params: map[string]string{"type_id_to_vindex": ""},
						Owner:  "",
					},
				},
			)

			if err != nil {
				t.Fatal(err)
			}

			actual, err := multisharded.(*MultiSharded).Verify(context.Background(), nil, c.rowsColValues, c.ksids)
			if !c.shouldErr {
				if err != nil {
					t.Fatal(err)
				}

				diff := cmp.Diff(actual, c.expected)
				if diff != "" {
					t.Errorf("Got unexpected result from multisharded.Verify. Expected: %v. Actual: %v.", c.expected, actual)
				}
			} else {
				if err == nil {
					t.Errorf("Expected error from multisharded.Verify, got nil")
				}
			}

		})
	}
}

func TestMultiShardedCost(t *testing.T) {
	cases := []struct {
		name           string
		costs          []string
		typeIdToVindex string
		expected       int
	}{
		{
			"No subvindexes",
			[]string{"2", "3", "4"},
			`{}`,
			0,
		},
		{
			"Only subset of all vindexes in vschema used",
			[]string{"1", "2", "3"},
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
			2,
		},
		{
			"All costs are 0",
			[]string{"0", "0", "0"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			0,
		},
		{
			"All costs are 1",
			[]string{"1", "1", "1"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			1,
		},
		{
			"Greatest cost is 2",
			[]string{"0", "2", "0"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			2,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {

			stubVindexSchema := map[string]*vschemapb.Vindex{
				"subvindex_a": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"cost": c.costs[0]},
					Owner:  "",
				},
				"subvindex_b": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"cost": c.costs[1]},
					Owner:  "",
				},
				"subvindex_c": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"cost": c.costs[2]},
					Owner:  "",
				},
				"multisharded_test": &vschemapb.Vindex{
					Type:   "etsy_multisharded_hybrid",
					Params: map[string]string{"type_id_to_vindex": ""},
					Owner:  "",
				},
			}

			// create multisharded vindex
			params := map[string]string{
				"type_id_to_vindex": c.typeIdToVindex,
			}
			multisharded, err := CreateVindex("etsy_multisharded_hybrid", "multisharded_test", params, stubVindexSchema)
			if err != nil {
				t.Fatal(err)
			}

			actual := multisharded.Cost()
			if actual != c.expected {
				t.Errorf("Expected cost %d, got %d", c.expected, actual)
			}

		})
	}
}

func TestMultiShardedIsUnique(t *testing.T) {
	cases := []struct {
		name           string
		isUnique       []string
		typeIdToVindex string
		expected       bool
	}{
		{
			"No subvindexes",
			[]string{"false", "false", "false"},
			`{}`,
			true,
		},
		{
			"Only subset of all vindexes in vschema used",
			[]string{"false", "false", "true"},
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
			false,
		},
		{
			"All subvindexes are unique",
			[]string{"true", "true", "true"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			true,
		},
		{
			"All subvindexes are not unique",
			[]string{"false", "false", "false"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			false,
		},
		{
			"Some subvindexes are unique",
			[]string{"true", "false", "true"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			false,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {

			stubVindexSchema := map[string]*vschemapb.Vindex{
				"subvindex_a": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"is_unique": c.isUnique[0]},
					Owner:  "",
				},
				"subvindex_b": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"is_unique": c.isUnique[1]},
					Owner:  "",
				},
				"subvindex_c": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"is_unique": c.isUnique[2]},
					Owner:  "",
				},
				"multisharded_test": &vschemapb.Vindex{
					Type:   "etsy_multisharded_hybrid",
					Params: map[string]string{"type_id_to_vindex": ""},
					Owner:  "",
				},
			}

			// create multisharded vindex
			params := map[string]string{
				"type_id_to_vindex": c.typeIdToVindex,
			}
			multisharded, err := CreateVindex("etsy_multisharded_hybrid", "multisharded_test", params, stubVindexSchema)
			if err != nil {
				t.Fatal(err)
			}

			actual := multisharded.IsUnique()
			if actual != c.expected {
				t.Errorf("Expected IsUnique result %v, got %v", c.expected, actual)
			}

		})
	}
}

func TestMultiShardedNeedsVCursor(t *testing.T) {
	cases := []struct {
		name           string
		needsVCursor   []string
		typeIdToVindex string
		expected       bool
	}{
		{
			"No subvindexes",
			[]string{"true", "true", "true"},
			`{}`,
			false,
		},
		{
			"Only subset of all vindexes in vschema used",
			[]string{"false", "false", "true"},
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
			false,
		},
		{
			"No subvindexes need Vcursor",
			[]string{"false", "false", "false"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			false,
		},
		{
			"All subvindexes need Vcursor",
			[]string{"true", "true", "true"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			true,
		},
		{
			"1 subvindex needs Vcursor",
			[]string{"true", "false", "false"},
			`{"1":"subvindex_a", "2":"subvindex_b", "3":"subvindex_c"}`,
			true,
		},
	}

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			stubVindexSchema := map[string]*vschemapb.Vindex{
				"subvindex_a": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"needs_vcursor": c.needsVCursor[0]},
					Owner:  "",
				},
				"subvindex_b": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"needs_vcursor": c.needsVCursor[1]},
					Owner:  "",
				},
				"subvindex_c": &vschemapb.Vindex{
					Type:   "singlecol_stub",
					Params: map[string]string{"needs_vcursor": c.needsVCursor[2]},
					Owner:  "",
				},
				"multisharded_test": &vschemapb.Vindex{
					Type:   "etsy_multisharded_hybrid",
					Params: map[string]string{"type_id_to_vindex": ""},
					Owner:  "",
				},
			}
			// create multisharded vindex
			params := map[string]string{
				"type_id_to_vindex": c.typeIdToVindex,
			}
			multisharded, err := CreateVindex("etsy_multisharded_hybrid", "multisharded_test", params, stubVindexSchema)
			if err != nil {
				t.Fatal(err)
			}

			actual := multisharded.NeedsVCursor()
			if actual != c.expected {
				t.Errorf("Expected NeedsVCursor result %v, got %v", c.expected, actual)
			}

		})
	}
}

// Setup for subvindex stubs

type MockFunctionSet struct {
	mapFunc    func(ids []sqltypes.Value) ([]key.Destination, error)
	verifyFunc func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error)
}

func buildMockFunctions() map[string]MockFunctionSet {
	mockFunctions := make(map[string]MockFunctionSet)
	mockFunctions["multisharded_test_subvindex_a"] = MockFunctionSet{
		mapFunc: func(ids []sqltypes.Value) ([]key.Destination, error) {
			res := make([]key.Destination, 0, len(ids))
			for _, id := range ids {
				switch id.ToString() {
				case "1", "2", "3":
					res = append(res, key.DestinationKeyspaceID([]byte("10")))
				case "4", "5", "6":
					res = append(res, key.DestinationKeyspaceID([]byte("20")))
				default:
					res = append(res, key.DestinationNone{})
				}
			}
			return res, nil
		},
		verifyFunc: func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
			res := make([]bool, 0, len(ids))
			for i, id := range ids {
				switch id.ToString() {
				case "1", "2", "3":
					if bytes.Equal(ksids[i], []byte("10")) || bytes.Equal(ksids[i], []byte("20")) {
						res = append(res, true)
					} else {
						res = append(res, false)
					}
				case "4", "5", "6":
					if bytes.Equal(ksids[i], []byte("100")) || bytes.Equal(ksids[i], []byte("200")) {
						res = append(res, true)
					} else {
						res = append(res, false)
					}
				default:
					res = append(res, false)
				}
			}
			return res, nil
		},
	}

	mockFunctions["multisharded_test_subvindex_b"] = MockFunctionSet{
		mapFunc: func(ids []sqltypes.Value) ([]key.Destination, error) {
			res := make([]key.Destination, 0, len(ids))
			for _, id := range ids {
				switch id.ToString() {
				case "10", "20", "30":
					res = append(res, key.DestinationKeyspaceID([]byte("100")))
				case "40", "50", "60":
					res = append(res, key.DestinationKeyspaceID([]byte("200")))
				default:
					res = append(res, key.DestinationNone{})
				}
			}
			return res, nil
		},
		verifyFunc: func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
			res := make([]bool, 0, len(ids))
			for i, id := range ids {
				switch id.ToString() {
				case "10", "20", "30":
					if bytes.Equal(ksids[i], []byte("30")) || bytes.Equal(ksids[i], []byte("40")) {
						res = append(res, true)
					} else {
						res = append(res, false)
					}
				case "40", "50", "60":
					if bytes.Equal(ksids[i], []byte("300")) || bytes.Equal(ksids[i], []byte("400")) {
						res = append(res, true)
					} else {
						res = append(res, false)
					}
				default:
					res = append(res, false)
				}
			}
			return res, nil
		},
	}

	mockFunctions["multisharded_test_subvindex_c"] = MockFunctionSet{
		mapFunc:    nil,
		verifyFunc: nil,
	}
	return mockFunctions
}

type SinglecolStub struct {
	name   string
	params map[string]string

	costFunc         func() int
	isUniqueFunc     func() bool
	needsVCursorFunc func() bool
	stringFunc       func() string
	mapFunc          func(ids []sqltypes.Value) ([]key.Destination, error)
	verifyFunc       func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error)
}

func NewSinglecolStub(name string, m map[string]string, _ map[string]*vschemapb.Vindex) (Vindex, error) {
	mockFunctions := buildMockFunctions()

	var costFunc func() int
	if costStr, ok := m["cost"]; !ok {
		costFunc = nil
	} else {
		costFunc = func() int {
			cost, _ := strconv.Atoi(costStr)
			return cost
		}
	}

	var isUniqueFunc func() bool
	if isUniqueStr, ok := m["is_unique"]; !ok {
		isUniqueFunc = nil
	} else {
		isUniqueFunc = func() bool {
			return isUniqueStr == "true"
		}
	}

	var needsVCursorFunc func() bool
	if needsVCursorStr, ok := m["needs_vcursor"]; !ok {
		needsVCursorFunc = nil
	} else {
		needsVCursorFunc = func() bool {
			return needsVCursorStr == "true"
		}
	}

	return &SinglecolStub{
		name:             name,
		params:           m,
		mapFunc:          mockFunctions[name].mapFunc,
		verifyFunc:       mockFunctions[name].verifyFunc,
		costFunc:         costFunc,
		isUniqueFunc:     isUniqueFunc,
		needsVCursorFunc: needsVCursorFunc,
	}, nil
}

func (s *SinglecolStub) Cost() int {
	return s.costFunc()
}

func (s *SinglecolStub) IsUnique() bool {
	return s.isUniqueFunc()
}

func (s *SinglecolStub) NeedsVCursor() bool {
	return s.needsVCursorFunc()
}

func (s *SinglecolStub) String() string {
	return s.stringFunc()
}

func (s *SinglecolStub) Map(ctx context.Context, vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	return s.mapFunc(ids)
}

func (s *SinglecolStub) Verify(ctx context.Context, vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	return s.verifyFunc(ids, ksids)
}
