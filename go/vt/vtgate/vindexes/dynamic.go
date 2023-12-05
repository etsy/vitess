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
	"encoding/json"
)

var (
	_ MultiColumn = (*Dynamic)(nil)
)

// Register the new vindex type
// New vindexes under this type will be created
// using the provided callback
func init() {
	Register("etsy_dynamic", NewDynamic)
}

// VindexMap stores a mapping of vindex id to vindex
type VindexMap map[uint64]Hybrid

// vindex definition in vschema
type VindexRef map[string]string

// defines a vindex that dynamically selects
// the vindex specified by a column value
type Dynamic struct {
	name      	string
	vindexMap	VindexMap
}

// create a new Dynamic vindex instance
func NewDynamic(name string, params map[string]string) (Vindex, error) {
	vmPath := params["vindex_map_path"]
	vmap := make(map[uint64]VindexRef)

	data, err := os.ReadFile(vmPath)
	if err != nil {
		return nil, err
	}

	log.Infof("Loaded vindex map from: %s", vmPath)

	err = json.Unmarshal(data, &vmap)
	if err != nil {
		return nil, err
	}

	// because we can't access the registered vindexes here,
	// we have to create all the candidate vindexes
	// and attach them to this vindex instance
	for id, vindexDef := range vmap {
		vParams := vindexDef["params"]
		vType := vindexDef["type"]
		v, err := CreateVindex(vType, name+"_"+id+"_"+vType, vParams)

		if err != nil {
			return nil, err
		}

		vindexMap[id] = v
	}

	return &Dynamic{
		name: name,
		vindexMap: vindexMap,
	}, nil
}

// String returns the name of the vindex.
func (d *Dynamic) String() string {
	return d.name
}

// Cost returns the cost of this vindex as the larger of its two component vindex costs.
func (d *Dynamic) Cost() int {
	maxCost := 0

	for _, vindex := range d.vindexMap {
		if vindex.Cost() > maxCost {
			maxCost = vindex.Cost()
		}
	}

	return maxCost
}

// IsUnique returns whether all of its candidate vindexes are unique.
func (d *Dynamic) IsUnique() bool {
	isUnique := true

	for _, vindex := range d.vindexMap {
		isUnique = isUnique && vindex.IsUnique()
	}

	return isUnique
}

// NeedsVCursor returns whether any of its component vindexes needs to execute queries to VTTablet.
func (d *Dynamic) NeedsVCursor() bool {
	needsVCursor := false

	for _, vindex := range d.vindexMap {
		needsVCursor = needsVCursor || vindex.NeedsVCursor()
	}

	return needsVCursor
}

func (d *Dynamic) Map(ctx context.Context, vcursor VCursor, rowsColValues [][]sqltypes.Value) ([]key.Destination, error) {
	destinations := make([]key.Destination, 0, len(rowsColValues))

	for _, colValues := range rowsColValues {
		if len(colValues) != 2 {
			destinations = append(destinations, key.DestinationNone{})
			continue
		}

		shardifierTypeId := colValues[0]
		shardifierValue := make([]sqltypes.Value, colValues[1])

		vindex := d.vindexMap[shardifierTypeId]

		res, err := vindex.Map(ctx, vcursor, shardifierValue)
		if err != nil {
			return nil, err
		}

		destinations = append(destinations, res)
	}

	return destinations, err
}

// Verify returns true for every id that successfully maps to the
// specified keyspace id.
func (d *Dynamic) Verify(ctx context.Context, vcursor VCursor, rowsColValues [][]sqltypes.Value, ksids [][]byte) ([]bool, error) {
	result := make([]bool, len(rowsColValues))
	destinations, _ := rv.Map(ctx, vcursor, rowsColValues)
	for i, dest := range destinations {
		destksid, ok := dest.(key.DestinationKeyspaceID)
		if !ok {
			continue
		}
		result[i] = bytes.Equal([]byte(destksid), ksids[i])
	}
	return result, nil
}

// PartialVindex returns true if subset of columns can be passed in to the vindex Map and Verify function.
func (d *Dynamic) PartialVindex() bool {
	return false
}