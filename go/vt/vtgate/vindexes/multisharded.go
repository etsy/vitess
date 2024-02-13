/*
Copyright 2024 The Vitess Authors.

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
	"encoding/json"
	"fmt"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
	"vitess.io/vitess/go/vt/vtgate/evalengine"
)

var _ MultiColumn = (*MultiSharded)(nil)

func init() {
	Register("etsy_multisharded", NewMultiSharded)
}

type MultiSharded struct {
	name               string
	typeIdToVindexName map[string]string
	subvindexMap       map[string]SingleColumn
}

func NewMultiSharded(name string, m map[string]string) (Vindex, error) {

	var typeIdToVindexName map[string]string
	err := json.Unmarshal([]byte(m["owner_type_to_vindex"]), &typeIdToVindexName)
	if err != nil {
		return nil, err
	}

	subvindexMap := make(map[string]SingleColumn)
	for _, vindexName := range typeIdToVindexName {
		if _, ok := hybridVindexes[vindexName]; ok {
			subvindexMap[vindexName] = hybridVindexes[vindexName]
		}
	}

	return &MultiSharded{
		name:               name,
		typeIdToVindexName: typeIdToVindexName,
		subvindexMap:       subvindexMap,
	}, nil
}

func (m *MultiSharded) String() string {
	return m.name
}

func (m *MultiSharded) Cost() int {
	cost := 0
	for _, subvindex := range m.subvindexMap {
		if subvindex == nil {
			continue
		}
		subvindexCost := subvindex.Cost()
		if subvindexCost > cost {
			cost = subvindexCost
		}
	}
	return cost
}

func (m *MultiSharded) IsUnique() bool {
	for _, subvindex := range m.subvindexMap {
		if subvindex == nil {
			continue
		}

		if !subvindex.IsUnique() {
			return false
		}
	}
	return true
}

func (m *MultiSharded) NeedsVCursor() bool {
	for _, subvindex := range m.subvindexMap {
		if subvindex == nil {
			continue
		}

		if subvindex.NeedsVCursor() {
			return true
		}
	}
	return false
}

func (m *MultiSharded) PartialVindex() bool {
	return false
}

func (m *MultiSharded) Map(ctx context.Context, vcursor VCursor, rowsColValues [][]sqltypes.Value) ([]key.Destination, error) {
	out := make([]key.Destination, len(rowsColValues))
	subvindexToRowsColValues, _, err := m.separateBySubvindex(rowsColValues, nil)
	if err != nil {
		return nil, err
	}

	subvindexToResult := make(map[string][]key.Destination)
	for subvindexName, colValues := range subvindexToRowsColValues {
		ids := make([]sqltypes.Value, 0, len(colValues))
		for _, colValue := range colValues {
			ids = append(ids, colValue[1])
		}
		res, err := m.subvindexMap[subvindexName].Map(ctx, vcursor, ids)
		if err != nil {
			return nil, err
		}

		subvindexToResult[subvindexName] = res
	}

	// ensure results are in same order as rowsColsValues
	subvindexToIndex := make(map[string]int)
	for subvindex := range subvindexToResult {
		subvindexToIndex[subvindex] = 0
	}

	for i, colValues := range rowsColValues {
		found := false
		typeIdString := colValues[0].ToString()
		idString := colValues[1].ToString()

		for subvindex, subvindexRowsColValues := range subvindexToRowsColValues {
			idx := subvindexToIndex[subvindex]
			if idx >= len(subvindexToRowsColValues[subvindex]) {
				continue
			}
			subvindexColValues := subvindexRowsColValues[idx]
			if typeIdString == subvindexColValues[0].ToString() && idString == subvindexColValues[1].ToString() {
				res := subvindexToResult[subvindex][idx]
				out[i] = res
				subvindexToIndex[subvindex]++
				found = true
				break
			}
		}

		if !found {
			return nil, fmt.Errorf("MultiSharded.Map: no result found for input column values %v", colValues)
		}
	}

	return out, nil
}

func (m *MultiSharded) Verify(ctx context.Context, vcursor VCursor, rowsColValues [][]sqltypes.Value, ksids [][]byte) ([]bool, error) {
	out := make([]bool, len(rowsColValues))

	subvindexToRowsColValues, subvindexToKsids, err := m.separateBySubvindex(rowsColValues, ksids)
	if err != nil {
		return nil, err
	}

	subvindexToResult := make(map[string][]bool)
	for subvindexName, colValues := range subvindexToRowsColValues {
		ids := make([]sqltypes.Value, 0, len(colValues))
		subvindexKsids := subvindexToKsids[subvindexName]
		for _, colValue := range colValues {
			ids = append(ids, colValue[1])
		}
		res, err := m.subvindexMap[subvindexName].Verify(ctx, vcursor, ids, subvindexKsids)
		if err != nil {
			return nil, err
		}

		subvindexToResult[subvindexName] = res
	}

	// ensure results are in same order as rowsColsValues & ksids
	subvindexToIndex := make(map[string]int)
	for subvindexName := range subvindexToResult {
		subvindexToIndex[subvindexName] = 0
	}

	for i, colValues := range rowsColValues {
		found := false
		typeIdString := colValues[0].ToString()
		idString := colValues[1].ToString()

		for subvindexName, subvindexRowsColValues := range subvindexToRowsColValues {
			idx := subvindexToIndex[subvindexName]
			if idx >= len(subvindexToRowsColValues[subvindexName]) {
				continue
			}
			subvindexColValues := subvindexRowsColValues[idx]
			if typeIdString == subvindexColValues[0].ToString() && idString == subvindexColValues[1].ToString() {
				res := subvindexToResult[subvindexName][idx]
				out[i] = res
				subvindexToIndex[subvindexName]++
				found = true
				break
			}
		}

		if !found {
			return nil, fmt.Errorf("Multisharded.Verify: no result found for input column values %v with ksid %v", colValues, ksids[i])
		}
	}

	return out, nil

}

func (m *MultiSharded) separateBySubvindex(rowsColValues [][]sqltypes.Value, ksids [][]byte) (map[string][][]sqltypes.Value, map[string][][]byte, error) {
	var subvindexToRowsColValues = make(map[string][][]sqltypes.Value)
	var subvindexToKsids = make(map[string][][]byte)
	for i, colValues := range rowsColValues {
		subvindexName, ok := m.typeIdToVindexName[colValues[0].ToString()]
		if !ok {
			return nil, nil, fmt.Errorf("MultiSharded.separateBySubvindex: no subvindex found for typeId %v with id %v", colValues[0], colValues[1])
		}

		// Check if id is valid
		_, err := evalengine.ToUint64(colValues[1])
		if err != nil {
			return nil, nil, err
		}
		subvindexToRowsColValues[subvindexName] = append(subvindexToRowsColValues[subvindexName], colValues)

		if len(ksids) > 0 {
			subvindexToKsids[subvindexName] = append(subvindexToKsids[subvindexName], ksids[i])
		}
	}
	return subvindexToRowsColValues, subvindexToKsids, nil
}
