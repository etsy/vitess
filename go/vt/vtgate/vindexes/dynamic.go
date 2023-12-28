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
	"fmt"
	"os"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
	"vitess.io/vitess/go/vt/log"
	"vitess.io/vitess/go/vt/vtgate/evalengine"

	jsref "github.com/lestrrat-go/jsref"
	"github.com/lestrrat-go/jsref/provider"
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

// a mapping of vindex id to vindex
type VindexMap map[string]SingleColumn

// defines a vindex that dynamically selects
// the vindex specified by a column value
type Dynamic struct {
	name      string
	vindexMap VindexMap
}

// create a new Dynamic vindex instance
func NewDynamic(name string, params map[string]string) (Vindex, error) {
	// In order to access to the registered vindexes here, we have to either:
	//
	// A) pass the instantiated vschema object to CreateVindex call in vschema.buildTables(),
	// then access the registered vindexes via vschema.FindVindex()
	// (See go/vt/vtgate/vindexes/vschema.go#L250)
	// B) create all the candidate vindexes and attach them to this vindex instance
	//
	// Let's try option B

	// First, load the vschema file into memory
	vschemaPath := "./vschema_test.json"
	vschema := make(map[string]any)
	ParseFile(vschemaPath, &vschema)

	// Set the vschema as the external reference
	mp := provider.NewMap()
	mp.Set(vschemaPath, vschema)
	jsResolver := jsref.New()
	jsResolver.AddProvider(mp)

	// Read the vindex map file
	vmPath := params["vindex_map_path"]
	vDefs := make(map[string]any)
	ParseFile(vmPath, &vDefs)

	vMap := make(VindexMap)

	for id, _ := range vDefs {
		// resolve vindex definitions using json external references
		ptr := fmt.Sprintf("#/%s", id)
		result, err := jsResolver.Resolve(vDefs, ptr)

		if err != nil {
			fmt.Printf("[Dynamic Vindex] json ref resolution err: %s\n", err)
			continue
		}

		vparams := result.(map[string]any)["params"].(map[string]string)
		vtype := result.(map[string]any)["type"].(string)

		vname := name + "_" + id + "_" + vtype
		vindex, err := CreateVindex(vtype, vname, vparams)

		if err != nil {
			return nil, err
		}

		vindex, ok := vindex.(SingleColumn)

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

func ParseFile(filepath string, format *map[string]any) {
	data, err := os.ReadFile(filepath)
	if err != nil {
		fmt.Printf("[Dynamic Vindex] file loading error\n")
	}

	if err := json.Unmarshal(data, &format); err != nil {
		fmt.Printf("[Dynamic Vindex] json unmarshalling error:\n%s\n", err)
	}
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

		log.Infof("[Dynamic Vindex] vindex %s Map() ran successfully", vindex.String())

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
