/*
Copyright 2022 The Vitess Authors.

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

package reference

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/mysql"
	"vitess.io/vitess/go/test/endtoend/utils"
)

func start(t *testing.T) (*mysql.Conn, func()) {
	ctx := context.Background()
	vtConn, err := mysql.Connect(ctx, &vtParams)
	require.NoError(t, err)

	return vtConn, func() {
		vtConn.Close()
	}
}

// TestGlobalReferenceRouting tests that unqualified queries for reference
// tables go to the right place.
//
// Given:
//   - Unsharded keyspace `uks` and sharded keyspace `sks`.
//   - Source table `uks.zip_detail` and a reference table `sks.zip_detail`,
//     initially with the same rows.
//   - Unsharded table `uks.zip` and sharded table `sks.delivery_failure`.
//
// When: we execute `INSERT INTO zip_detail ...`,
// Then: `zip_detail` should be routed to `uks`.
//
// When: we execute `UPDATE zip_detail ...`,
// Then: `zip_detail` should be routed to `uks`.
//
// When: we execute `SELECT ... FROM zip JOIN zip_detail ...`,
// Then: `zip_detail` should be routed to `uks`.
//
// When: we execute `SELECT ... FROM delivery_failure JOIN zip_detail ...`,
// Then: `zip_detail` should be routed to `sks`.
//
// When: we execute `DELETE FROM zip_detail ...`,
// Then: `zip_detail` should be routed to `uks`.
func TestReferenceRouting(t *testing.T) {
	conn, closer := start(t)
	defer closer()

	// INSERT should route an unqualified zip_detail to unsharded keyspace.
	utils.Exec(t, conn, "INSERT INTO zip_detail(id, zip_id, discontinued_at) VALUES(3, 1, DATE('2022-12-03'))")
	// Verify with qualified zip_detail queries to each keyspace. The unsharded
	// keyspace should have an extra row.
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(zd.id) FROM "+unshardedKeyspaceName+".zip_detail zd WHERE id = 3",
		`[[INT64(1)]]`,
	)
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(zd.id) FROM "+shardedKeyspaceName+".zip_detail zd WHERE id = 3",
		`[[INT64(0)]]`,
	)

	t.Run("Complex reference query", func(t *testing.T) {
		// Verify a complex query using reference tables with a left join having a derived table with an order by clause works as intended.
		utils.AssertMatches(
			t,
			conn,
			`SELECT t.id FROM (
						SELECT zd.id, zd.zip_id
						FROM `+shardedKeyspaceName+`.zip_detail AS zd
						WHERE zd.id IN (2)
						ORDER BY zd.discontinued_at
						LIMIT 1
				) AS t
				LEFT JOIN `+shardedKeyspaceName+`.zip_detail AS t0 ON t.zip_id = t0.zip_id
				ORDER BY t.id`,
			`[[INT64(2)]]`,
		)
	})

	// UPDATE should route an unqualified zip_detail to unsharded keyspace.
	utils.Exec(t, conn,
		"UPDATE zip_detail SET discontinued_at = NULL WHERE id = 2")
	// Verify with qualified zip_detail queries to each keyspace. The unsharded
	// keyspace should have a matching row, but not the sharded keyspace.
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(id) FROM "+unshardedKeyspaceName+".zip_detail WHERE discontinued_at IS NULL",
		`[[INT64(1)]]`,
	)
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(id) FROM "+shardedKeyspaceName+".zip_detail WHERE discontinued_at IS NULL",
		`[[INT64(0)]]`,
	)

	// SELECT a table in unsharded keyspace and JOIN unqualified zip_detail.
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(zd.id) FROM zip z JOIN zip_detail zd ON z.id = zd.zip_id WHERE zd.id = 3",
		`[[INT64(1)]]`,
	)

	// SELECT a table in sharded keyspace and JOIN unqualified zip_detail.
	// Use gen4 planner to avoid errors from gen3 planner.
	utils.AssertMatches(
		t,
		conn,
		`SELECT COUNT(zd.id)
		 FROM delivery_failure df
		 JOIN zip_detail zd ON zd.id = df.zip_detail_id WHERE zd.id = 3`,
		`[[INT64(0)]]`,
	)

	// DELETE should route an unqualified zip_detail to unsharded keyspace.
	utils.Exec(t, conn, "DELETE FROM zip_detail")
	// Verify with qualified zip_detail queries to each keyspace. The unsharded
	// keyspace should not have any rows; the sharded keyspace should.
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(id) FROM "+unshardedKeyspaceName+".zip_detail",
		`[[INT64(0)]]`,
	)
	utils.AssertMatches(
		t,
		conn,
		"SELECT COUNT(id) FROM "+shardedKeyspaceName+".zip_detail",
		`[[INT64(2)]]`,
	)
}

// TestMultiReferenceQuery tests that a query with multiple references with unsharded keyspace and sharded keyspace works with join.
func TestMultiReferenceQuery(t *testing.T) {
	utils.SkipIfBinaryIsBelowVersion(t, 21, "vtgate")
	conn, closer := start(t)
	defer closer()

	query :=
		`select 1
		 from delivery_failure df1
		 	join delivery_failure df2 on df1.id = df2.id
		 	join uks.zip_detail zd1 on df1.zip_detail_id = zd1.zip_id
		 	join uks.zip_detail zd2 on zd1.zip_id = zd2.zip_id`

	utils.Exec(t, conn, query)
}

func TestDMLReferenceUsingShardedKS(t *testing.T) {
	utils.SkipIfBinaryIsBelowVersion(t, 21, "vtgate")
	conn, closer := start(t)
	defer closer()

	utils.Exec(t, conn, "use sks")
	utils.Exec(t, conn, "update zip_detail set zip_id = 1 where id = 1")
}
