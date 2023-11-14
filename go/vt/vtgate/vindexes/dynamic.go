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
type VindexMap map[uint64]Vindex

// defines a vindex that dynamically selects
// the vindex specified by a column value
type Dynamic struct {
	name      	string
	vindexMap	VindexMap
}

// create a new Dynamic vindex instance
// based on the properties specified in the input map
func NewDynamic(name string, params map[string]string) (Vindex, error) {
	vindexMap := make([uint64]Vindex, 0, len(params["vindex_map"]))

	for id, vindexName := range params["vindex_map"] {
		v, err := CreateVindex(vindexName, name+"_"+vindexName, params)

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

	// optimization: create set of unique vindexes to loop through?
	for id, vindex := range d.vindexMap {

	}
}

// IsUnique returns whether both of its component vindexes are unique.
func (d *Dynamic) IsUnique() bool {
	return h.vindexA.IsUnique() && h.vindexB.IsUnique()
}

// NeedsVCursor returns whether either of its component vindexes needs to execute queries to VTTablet.
func (d *Dynamic) NeedsVCursor() bool {
	return h.vindexA.NeedsVCursor() || h.vindexB.NeedsVCursor()
}

func (d *Dynamic) Map(ctx context.Context, vcursor VCursor, rowsColValues [][]sqltypes.Value) ([]key.Destination, error) {
	destinations := make([]key.Destination, 0, len(rowsColValues))

	for _, colValues := range rowsColValues {
		if len(colValues) != 2 {
			destinations = append(destinations, key.DestinationNone{})
			continue
		}

		typeId := colValues[0]
		shardifier := colValues[1]

		vindex := d.vindexMap[typeId]

		res, err := vindex.Map(ctx, vcursor, shardifier)
		if err != nil {
			return nil, err
		}

		destinations = append(destinations, res)
	}

	return destinations, err
}