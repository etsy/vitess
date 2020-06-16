package vtgate

import (
	"testing"

	"golang.org/x/net/context"
	"vitess.io/vitess/go/sqltypes"
	"vitess.io/vitess/go/vt/discovery"
	"vitess.io/vitess/go/vt/key"

	querypb "vitess.io/vitess/go/vt/proto/query"
	topodatapb "vitess.io/vitess/go/vt/proto/topodata"
	vtgatepb "vitess.io/vitess/go/vt/proto/vtgate"
)

func TestResolverStreamSetWorkload(t *testing.T) {
	keyspace := "TestResolverStreamSetWorkload"
	createSandbox(keyspace)
	hc := discovery.NewFakeHealthCheck()
	res := newTestResolver(hc, new(sandboxTopo), "aa")

	testcases := []struct {
		in  string
		out *vtgatepb.Session
		err string
	}{{
		in:  "set workload = 'unspecified'",
		out: &vtgatepb.Session{Autocommit: true, Options: &querypb.ExecuteOptions{Workload: querypb.ExecuteOptions_UNSPECIFIED}},
	}, {
		in:  "set workload = 'oltp'",
		out: &vtgatepb.Session{Autocommit: true, Options: &querypb.ExecuteOptions{Workload: querypb.ExecuteOptions_OLTP}},
	}, {
		in:  "set workload = 'olap'",
		out: &vtgatepb.Session{Autocommit: true, Options: &querypb.ExecuteOptions{Workload: querypb.ExecuteOptions_OLAP}},
	}, {
		in:  "set workload = 'dba'",
		out: &vtgatepb.Session{Autocommit: true, Options: &querypb.ExecuteOptions{Workload: querypb.ExecuteOptions_DBA}},
	}, {
		in:  "set workload = 'aa'",
		err: "invalid workload: aa",
	}, {
		in:  "set workload = 1",
		err: "unexpected value type for workload: int64",
	}, {
		in:  "set autocommit = 1",
		err: "unsupported construct: set autocommit = 1",
	}, {
		in:  "set names utf8",
		err: "unsupported construct: set names utf8",
	}}
	for _, tcase := range testcases {
		qr := new(sqltypes.Result)
		err := res.StreamExecute(context.Background(),
			tcase.in,
			nil,
			keyspace,
			topodatapb.TabletType_MASTER,
			key.DestinationKeyspaceIDs([][]byte{{0x10}, {0x15}}),
			NewSafeSession(primarySession),
			nil,
			func(r *sqltypes.Result) error {
				qr.AppendResult(r)
				return nil
			})

		if err != nil {
			if err.Error() != tcase.err {
				t.Errorf("%s error: %v, want %s", tcase.in, err, tcase.err)
			}
			continue
		}
		if primarySession.Options.Workload != tcase.out.Options.Workload {
			t.Errorf("%s: %v, want %s", tcase.in, primarySession, tcase.out)
		}
	}
}
