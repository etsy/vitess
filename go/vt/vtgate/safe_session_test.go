/*
Copyright 2020 The Vitess Authors.

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

package vtgate

import (
	"reflect"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	querypb "vitess.io/vitess/go/vt/proto/query"
	topodatapb "vitess.io/vitess/go/vt/proto/topodata"
	vtgatepb "vitess.io/vitess/go/vt/proto/vtgate"
)

func TestFailToMultiShardWhenSetToSingleDb(t *testing.T) {
	session := NewSafeSession(&vtgatepb.Session{
		InTransaction: true, TransactionMode: vtgatepb.TransactionMode_SINGLE,
	})

	sess0 := &vtgatepb.Session_ShardSession{
		Target:        &querypb.Target{Keyspace: "keyspace", Shard: "0"},
		TabletAlias:   &topodatapb.TabletAlias{Cell: "cell", Uid: 0},
		TransactionId: 1,
	}
	sess1 := &vtgatepb.Session_ShardSession{
		Target:        &querypb.Target{Keyspace: "keyspace", Shard: "1"},
		TabletAlias:   &topodatapb.TabletAlias{Cell: "cell", Uid: 1},
		TransactionId: 1,
	}

	err := session.AppendOrUpdate(sess0, vtgatepb.TransactionMode_SINGLE)
	require.NoError(t, err)
	err = session.AppendOrUpdate(sess1, vtgatepb.TransactionMode_SINGLE)
	require.Error(t, err)
}

func TestPrequeries(t *testing.T) {
	session := NewSafeSession(&vtgatepb.Session{
		SystemVariables: map[string]string{
			"s1": "'apa'",
			"s2": "42",
		},
	})

	want := []string{"set s1 = 'apa', s2 = 42"}
	preQueries := session.SetPreQueries()

	if !reflect.DeepEqual(want, preQueries) {
		t.Errorf("got %v but wanted %v", preQueries, want)
	}
}

func TestTimeZone(t *testing.T) {
	testCases := []struct {
		tz   string
		want string
	}{
		{
			tz:   "",
			want: time.Local.String(),
		},
		{
			tz:   "'Europe/Amsterdam'",
			want: "Europe/Amsterdam",
		},
		{
			tz:   "'+02:00'",
			want: "UTC+02:00",
		},
		{
			tz:   "foo",
			want: time.Local.String(),
		},
	}

	for _, tc := range testCases {
		t.Run(tc.tz, func(t *testing.T) {
			sysvars := map[string]string{}
			if tc.tz != "" {
				sysvars["time_zone"] = tc.tz
			}
			session := NewSafeSession(&vtgatepb.Session{
				SystemVariables: sysvars,
			})

			assert.Equal(t, tc.want, session.TimeZone().String())
		})
	}
}
