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
	"fmt"
	"strconv"

	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/key"
	"vitess.io/vitess/go/vt/vtgate/evalengine"
)

var (
	_ SingleColumn = (*Hybrid)(nil)
)

func init() {
	Register("etsy_hybrid", NewHybrid)
}

// Hybrid defines a vindex consisting of two vindexes.
// These can be applied in two ways:
//  1. 	If no threshold is provided or threshold = 0:
//			Always use vindex A and fall back to vindex B if A
//			does not return a result.
// 	2.  If threshold > 0:
//			Use vindex A if the value is below the threshold,
//			otherwise use vindex B.
type Hybrid struct {
	name      string
	vindexA   SingleColumn
	vindexB   SingleColumn
	threshold uint64
}

// NewHybrid creates a Hybrid vindex.
// The supplied map has the following required fields:
//
//	vindex_a: name of the first vindex
//	vindex_b: name of the second vindex
//	threshold: (optional) unsigned int value to compare to provided id
//	    if id < threshold, use vindex a, otherwise, choose b.
//
// The required fields from vindex a and vindex b should also be
// included in the supplied map
func NewHybrid(name string, m map[string]string) (Vindex, error) {
	h := &Hybrid{name: name}

	var err error
	threshold := m["threshold"]
	if threshold == "" {
		h.threshold = 0
	} else {
		h.threshold, err = strconv.ParseUint(threshold, 0, 64)
		if err != nil {
			return nil, err
		}
	}

	vindexA, err := CreateVindex(m["vindex_a"], name+"_a_"+m["vindex_a"], m)
	if err != nil {
		return nil, err
	}
	h.vindexA = vindexA.(SingleColumn)
	vindexB, err := CreateVindex(m["vindex_b"], name+"_b_"+m["vindex_b"], m)
	if err != nil {
		return nil, err
	}
	h.vindexB = vindexB.(SingleColumn)

	return h, nil
}

// String returns the name of the vindex.
func (h *Hybrid) String() string {
	return h.name
}

// Cost returns the cost of this vindex as the larger of its two component vindex costs.
func (h *Hybrid) Cost() int {
	if h.vindexA.Cost() > h.vindexB.Cost() {
		return (h.vindexA).Cost()
	}
	return (h.vindexB).Cost()
}

// IsUnique returns whether both of its component vindexes are unique.
func (h *Hybrid) IsUnique() bool {
	return h.vindexA.IsUnique() && h.vindexB.IsUnique()
}

// NeedsVCursor returns whether either of its component vindexes needs to execute queries to VTTablet.
func (h *Hybrid) NeedsVCursor() bool {
	return h.vindexA.NeedsVCursor() || h.vindexB.NeedsVCursor()
}

// Map maps an id to a key.Destination object. Because this vindex is unique, each id maps to a
// KeyRange or a single KeyspaceID.
// This mapping is used to determine which shard contains a row. If the id is absent from the vindex
// lookup table, Map returns key.DestinationNone{}, which does not map to any shard.
func (h *Hybrid) Map(ctx context.Context, vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	if (h.threshold > 0) {
		ret, err := h.mapWithThreshold(ctx, vcursor, ids)
		return ret, err
	}
	ret, err := h.mapWithFallback(ctx, vcursor, ids)
	return ret, err
}

func (h *Hybrid) mapWithThreshold(ctx context.Context, vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	out := make([]key.Destination, len(ids))
	var err error

	// Generate list of ids to send to each component vindex
	idsVindexA, _, idsVindexB, _, err := separateByThreshold(ids, nil, h.threshold)
	if err != nil {
		return nil, err
	}

	// Query component vindexes
	vindexARes, err := h.vindexA.Map(ctx, vcursor, idsVindexA)
	if err != nil {
		return nil, err
	}
	vindexBRes, err := h.vindexB.Map(ctx, vcursor, idsVindexB)
	if err != nil {
		return nil, err
	}

	// Build output by combining results
	a, b := 0, 0
	lenIdsVindexA := len(idsVindexA)
	lenIdsVindexB := len(idsVindexB)
	for i, id := range ids {
		idString := id.ToString()
		if lenIdsVindexA > a && idsVindexA[a].ToString() == idString {
			out[i] = vindexARes[a]
			a++
		} else if lenIdsVindexB > b && idsVindexB[b].ToString() == idString {
			out[i] = vindexBRes[b]
			b++
		} else {
			return nil, fmt.Errorf("Hybrid.Map: no result found for input id %v", id)
		}
	}

	return out, err
}

func (h *Hybrid) mapWithFallback(ctx context.Context, vcursor VCursor, ids []sqltypes.Value) ([]key.Destination, error) {
	out := make([]key.Destination, len(ids))
	var err error
	var	idsVindexB []sqltypes.Value

	for _, id := range ids {
		// Check that type is valid
		_, err := evalengine.ToUint64(id)
		if err != nil {
			return nil, err
		}
	}

	// Query first component vindex
	vindexARes, err := h.vindexA.Map(ctx, vcursor, ids)

	// Build list of ids that were not found in the first vindex
	for i, id := range ids {
		_, ok := vindexARes[i].(key.DestinationNone)
		if ok {
			idsVindexB = append(idsVindexB, id)
		}
	}

	// Query second component vindex
	vindexBRes, err := h.vindexB.Map(ctx, vcursor, idsVindexB)
	if err != nil {
		return nil, err
	}

	// Build output by combining results
	b := 0
	for i, id := range ids {
		idString := id.ToString()
		_, ok := vindexARes[i].(key.DestinationNone)
		if ok && idsVindexB[b].ToString() == idString {
			out[i] = vindexBRes[b]
			b++
		} else if ids[i].ToString() == idString {
			out[i] = vindexARes[i]
		} else {
			return nil, fmt.Errorf("Hybrid.Map: no result found for input id %v", id)
		}
	}

	return out, err
}

// Verify returns true if ids maps to ksids.
func (h *Hybrid) Verify(ctx context.Context, vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	if (h.threshold > 0) {
		out, err := h.verifyWithThreshold(ctx, vcursor, ids, ksids)
		return out, err
	}
	out, err := h.verifyWithFallback(ctx, vcursor, ids, ksids)
	return out, err
}

func (h *Hybrid) verifyWithThreshold(ctx context.Context, vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	out := make([]bool, len(ids))
	var err error

	// Generate list of ids to send to each component vindex
	idsVindexA, ksidsVindexA, idsVindexB, ksidsVindexB, err := separateByThreshold(ids, ksids, h.threshold)
	if err != nil {
		return nil, err
	}

	// Query component vindexes
	vindexARes, err := h.vindexA.Verify(ctx, vcursor, idsVindexA, ksidsVindexA)
	if err != nil {
		return nil, err
	}
	vindexBRes, err := h.vindexB.Verify(ctx, vcursor, idsVindexB, ksidsVindexB)
	if err != nil {
		return nil, err
	}

	// Build output by combining results
	a, b := 0, 0
	for i, id := range ids {
		idString := id.ToString()
		if len(idsVindexA) > a && idsVindexA[a].ToString() == idString {
			out[i] = vindexARes[a]
			a++
		} else if len(idsVindexB) > b && idsVindexB[b].ToString() == idString {
			out[i] = vindexBRes[b]
			b++
		} else {
			return nil, fmt.Errorf("Hybrid.Verify: no result found for input id %v", id)
		}
	}

	return out, err
}

func (h* Hybrid) verifyWithFallback(ctx context.Context, vcursor VCursor, ids []sqltypes.Value, ksids [][]byte) ([]bool, error) {
	out := make([]bool, len(ids))
	var err error

	var	idsVindexB []sqltypes.Value
	var	ksidsVindexB [][]byte

	// Query first component vindex
	vindexARes, err := h.vindexA.Verify(ctx, vcursor, ids, ksids)
	if err != nil {
		return nil, err
	}

	// Build lists of ids to send to each component vindex -
	// ids were found in vindex A and ids that were not found and will use vindex B
	for i, id := range ids {
		if (vindexARes[i] == false) {
			idsVindexB = append(idsVindexB, id)
			ksidsVindexB = append(ksidsVindexB, ksids[i])
		}
	}

	vindexBRes, err := h.vindexB.Verify(ctx, vcursor, idsVindexB, ksidsVindexB)
	if err != nil {
		return nil, err
	}

	// Build output by combining results
	b := 0
	for i, id := range ids {
		idString := id.ToString()
		if (vindexARes[i] == false && idsVindexB[b].ToString() == idString) {
			out[i] = vindexBRes[b]
			b++
		} else if ids[i].ToString() == idString {
			out[i] = vindexARes[i]
		} else {
			return nil, fmt.Errorf("Hybrid.Verify: no result found for input id %v", id)
		}
	}

	return out, err
}

func separateByThreshold(ids []sqltypes.Value, ksids [][]byte, threshold uint64) ([]sqltypes.Value, [][]byte, []sqltypes.Value, [][]byte, error) {
	var idsA []sqltypes.Value
	var ksidsA [][]byte
	var idsB []sqltypes.Value
	var ksidsB [][]byte

	for i, id := range ids {
		// Check that type is valid
		val, err := evalengine.ToUint64(id)
		if err != nil {
			return nil, nil, nil, nil, err
		}
		if val < threshold {
			idsA = append(idsA, id)
			if len(ksids) > 0 {
				ksidsA = append(ksidsA, ksids[i])
			}
		} else {
			idsB = append(idsB, id)
			if len(ksids) > 0 {
				ksidsB = append(ksidsB, ksids[i])
			}
		}
	}

	return idsA, ksidsA, idsB, ksidsB, nil
}
