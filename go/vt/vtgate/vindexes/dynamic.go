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
	"encoding/json"
	"os"
	"strconv"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
	"vitess.io/vitess/go/vt/log"
	"vitess.io/vitess/go/vt/vtgate/evalengine"
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

// vindex definition from vschema
type VindexDef struct {
	Params map[string]string `json:"params"`
	Type   string            `json:"type"`
}

// a mapping of vindex id to vindex
type VindexMap map[uint64]SingleColumn

// defines a vindex that dynamically selects
// the vindex specified by a column value
type Dynamic struct {
	name      string
	vindexMap VindexMap
}

// create a new Dynamic vindex instance
func NewDynamic(name string, params map[string]string) (Vindex, error) {
	vmPath := params["vindex_map_path"]

	data, err := os.ReadFile(vmPath)
	if err != nil {
		return nil, err
	}

	log.Infof("[Dynamic Vindex] Loaded file: %s", vmPath)

	vDefs := make(map[uint64]VindexDef)
	err = json.Unmarshal(data, &vDefs)
	if err != nil {
		return nil, err
	}

	log.Infof("[Dynamic Vindex] Parsed vindex map from: %s", vmPath)

	// because we can't access the registered vindexes here,
	// we have to create all the candidate vindexes
	// and attach them to this vindex instance
	vMap := make(VindexMap)

	for id, vindexDef := range vDefs {
		vname := name + "_" + strconv.FormatUint(id, 10) + "_" + vindexDef.Type
		v, err := CreateVindex(vindexDef.Type, vname, vindexDef.Params)

		if err != nil {
			return nil, err
		}

		vindex, ok := v.(SingleColumn)

		if ok == false {
			return nil, err
		}

		vMap[id] = vindex
	}

	return &Dynamic{
		name:      name,
		vindexMap: vMap,
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

	// TODO: figure out if it would be more performant
	// to call Map on each id
	// OR call Map on each group of ids of the same vindex
	// (ditto with Verify())
	for _, colValues := range rowsColValues {
		if len(colValues) != 2 {
			destinations = append(destinations, key.DestinationNone{})
			continue
		}

		vindexId, err := evalengine.ToUint64(colValues[0])
		if err != nil {
			return nil, err
		}

		vindex := d.vindexMap[vindexId]

		// put the id sqltypes.Value in an array
		id := []sqltypes.Value{colValues[1]}
		res, err := vindex.Map(ctx, vcursor, id)
		if err != nil {
			return nil, err
		}

		destinations = append(destinations, res[0])
	}

	return destinations, nil
}

// Verify returns true for every id that successfully maps to the
// specified keyspace id.
func (d *Dynamic) Verify(ctx context.Context, vcursor VCursor, rowsColValues [][]sqltypes.Value, ksids [][]byte) ([]bool, error) {
	out := make([]bool, 0, len(rowsColValues))

	for idx, colValues := range rowsColValues {
		vindexId, err := evalengine.ToUint64(colValues[0])
		if err != nil {
			return nil, err
		}

		vindex := d.vindexMap[vindexId]

		id := []sqltypes.Value{colValues[1]}
		ksid := [][]byte{ksids[idx]}
		res, err := vindex.Verify(ctx, vcursor, id, ksid)
		if err != nil {
			return nil, err
		}
		out = append(out, res[0])
	}

	return out, nil
}

// PartialVindex returns true if subset of columns
// can be passed in to the vindex Map and Verify function.
func (d *Dynamic) PartialVindex() bool {
	return false
}
