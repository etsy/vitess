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
	"fmt"
	"testing"

	"github.com/google/go-cmp/cmp"
	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
)

// Ensure that MultiSharded properties are correctly defined upon creation
func TestMultiShardedCreation(t *testing.T) {
	hybridVindexes = map[string]SingleColumn{
		"etsy_hybrid_user": &HybridStub{},
		"etsy_hybrid_shop": &HybridStub{},
	}

	params := map[string]string{
		"owner_type_to_vindex": `{"1":"etsy_hybrid_user", "2":"etsy_hybrid_shop"}`,
	}

	expectedName := "multisharded_test"
	multisharded, err := CreateVindex("etsy_multisharded", expectedName, params)
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

	expectedTypeIdToVindexName := map[string]string{"1": "etsy_hybrid_user", "2": "etsy_hybrid_shop"}
	diff := cmp.Diff(multisharded.(*MultiSharded).typeIdToVindexName,
		expectedTypeIdToVindexName)

	if diff != "" {
		t.Errorf(
			"Got unexpected value for multisharded.ownerTypeToVindexName. Expected: %v, Got: %v",
			expectedTypeIdToVindexName,
			multisharded.(*MultiSharded).typeIdToVindexName)
	}

	expectedSubvindexMap := map[string]SingleColumn{
		"etsy_hybrid_user": &HybridStub{},
		"etsy_hybrid_shop": &HybridStub{},
	}

	diff = cmp.Diff(multisharded.(*MultiSharded).subvindexMap,
		expectedSubvindexMap, cmp.AllowUnexported(HybridStub{}))

	if diff != "" {
		t.Errorf(
			"Got unexpected value for multisharded.subvindexMap. Expected: %v, Got: %v",
			expectedSubvindexMap,
			multisharded.(*MultiSharded).subvindexMap)
	}
}

func TestMultiShardedMap(t *testing.T) {
	cases := []struct {
		name              string
		ownerTypeToVindex string
		rowsColValues     [][]sqltypes.Value
		expected          []key.Destination
		shouldErr         bool
	}{
		{
			"All rows map to same subvindex",
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
			[][]sqltypes.Value{
				{sqltypes.NewInt64(100), sqltypes.NewInt64(1)},
				{sqltypes.NewInt64(200), sqltypes.NewInt64(60)},
				{sqltypes.NewInt64(500), sqltypes.NewInt64(70)},
			},
			nil,
			true,
		},
	}

	// TODO: Move this into helper?
	hybridVindexes = make(map[string]SingleColumn)
	hybridVindexes["subvindex_a"] = &HybridStub{
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
	}

	hybridVindexes["subvindex_b"] = &HybridStub{
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
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			multisharded, err := CreateVindex(
				"etsy_multisharded",
				"multisharded_test",
				map[string]string{"owner_type_to_vindex": c.ownerTypeToVindex})

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
		name              string
		ownerTypeToVindex string
		rowsColValues     [][]sqltypes.Value
		ksids             [][]byte
		expected          []bool
		shouldErr         bool
	}{
		{
			"Same subvindex, all ksids map correctly to ids",
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
			`{"1":"subvindex_a", "2":"subvindex_b"}`,
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
	}

	// TODO: Move this into helper?
	hybridVindexes = make(map[string]SingleColumn)
	hybridVindexes["subvindex_a"] = &HybridStub{
		verify: func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
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

	hybridVindexes["subvindex_b"] = &HybridStub{
		verify: func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
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
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			multisharded, err := CreateVindex(
				"etsy_multisharded",
				"multisharded_test",
				map[string]string{"owner_type_to_vindex": c.ownerTypeToVindex})

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
		name              string
		costs             []int
		ownerTypeToVindex string
		expected          int
	}{
		{"No subvindexes", []int{}, `{}`, 0},
		{"All costs are 0", []int{0, 0, 0}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, 0},
		{"All costs are 1", []int{1, 1, 1}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, 1},
		{"Greatest cost is 2", []int{0, 2, 0}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, 2},
	}

	for _, c := range cases {
		hybridVindexes = make(map[string]SingleColumn)
		t.Run(c.name, func(t *testing.T) {
			// Populate hybridVindexes with stub subvindexes
			for i, cost := range c.costs {
				costCopy := cost
				hybridVindexes[fmt.Sprintf("hybrid%d", i+1)] = &HybridStub{
					cost: func() int {
						return costCopy
					},
				}
			}

			// create multisharded vindex
			params := map[string]string{
				"owner_type_to_vindex": c.ownerTypeToVindex,
			}
			multisharded, err := CreateVindex("etsy_multisharded", "multisharded_test", params)
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
		name              string
		isUniqueResults   []bool
		ownerTypeToVindex string
		expected          bool
	}{
		{"No subvindexes", []bool{}, `{}`, true},
		{"All subvindexes are unique", []bool{true, true, true}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, true},
		{"All subvindexes are not unique", []bool{false, false, false}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, false},
		{"Some subvindexes are unique", []bool{true, false, true}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, false},
	}

	for _, c := range cases {
		hybridVindexes = make(map[string]SingleColumn)
		t.Run(c.name, func(t *testing.T) {
			// Populate hybridVindexes with stub subvindexes
			for i, isUnique := range c.isUniqueResults {
				isUniqueCopy := isUnique
				hybridVindexes[fmt.Sprintf("hybrid%d", i+1)] = &HybridStub{
					isUnique: func() bool {
						return isUniqueCopy
					},
				}
			}

			// create multisharded vindex
			params := map[string]string{
				"owner_type_to_vindex": c.ownerTypeToVindex,
			}
			multisharded, err := CreateVindex("etsy_multisharded", "multisharded_test", params)
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
		name                string
		needsVCursorResults []bool
		ownerTypeToVindex   string
		expected            bool
	}{
		{"No subvindexes", []bool{}, `{}`, false},
		{"No subvindexes need Vcursor", []bool{false, false, false}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, false},
		{"All subvindexes need Vcursor", []bool{true, true, true}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, true},
		{"1 subvindex needs Vcursor", []bool{true, false, false}, `{"1":"hybrid1", "2":"hybrid2", "3":"hybrid3"}`, true},
	}

	for _, c := range cases {
		hybridVindexes = make(map[string]SingleColumn)
		t.Run(c.name, func(t *testing.T) {
			// Populate hybridVindexes with stub subvindexes
			for i, needsVcursor := range c.needsVCursorResults {
				needsVCursorCopy := needsVcursor
				hybridVindexes[fmt.Sprintf("hybrid%d", i+1)] = &HybridStub{
					needsVCursor: func() bool {
						return needsVCursorCopy
					},
				}
			}

			// create multisharded vindex
			params := map[string]string{
				"owner_type_to_vindex": c.ownerTypeToVindex,
			}
			multisharded, err := CreateVindex("etsy_multisharded", "multisharded_test", params)
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

// Set up for subvindex stubs
type HybridStub struct {
	cost         func() int
	isUnique     func() bool
	needsVCursor func() bool
	stringFunc   func() string
	mapFunc      func(ids []sqltypes.Value) ([]key.Destination, error)
	verify       func(ids []sqltypes.Value, ksids [][]byte) ([]bool, error)
}

func (h *HybridStub) Cost() int {
	return h.cost()
}

func (h *HybridStub) IsUnique() bool {
	return h.isUnique()
}

func (h *HybridStub) NeedsVCursor() bool {
	return h.needsVCursor()
}

func (h *HybridStub) String() string {
	return h.stringFunc()
}

func (h *HybridStub) Map(ctx context.Context, vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	return h.mapFunc(ids)
}

func (h *HybridStub) Verify(ctx context.Context, vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	return h.verify(ids, ksids)
}
