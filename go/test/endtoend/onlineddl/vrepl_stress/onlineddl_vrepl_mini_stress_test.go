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

package vreplstress

import (
	"context"
	"flag"
	"fmt"
	"math/rand/v2"
	"os"
	"path"
	"runtime"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"vitess.io/vitess/go/mysql"
	"vitess.io/vitess/go/test/endtoend/cluster"
	"vitess.io/vitess/go/test/endtoend/onlineddl"
	"vitess.io/vitess/go/test/endtoend/throttler"
	"vitess.io/vitess/go/vt/log"
	"vitess.io/vitess/go/vt/schema"
	vttablet "vitess.io/vitess/go/vt/vttablet/common"
)

type WriteMetrics struct {
	mu                                                      sync.Mutex
	insertsAttempts, insertsFailures, insertsNoops, inserts int64
	updatesAttempts, updatesFailures, updatesNoops, updates int64
	deletesAttempts, deletesFailures, deletesNoops, deletes int64
}

func (w *WriteMetrics) Clear() {
	w.mu.Lock()
	defer w.mu.Unlock()

	w.inserts = 0
	w.updates = 0
	w.deletes = 0

	w.insertsAttempts = 0
	w.insertsFailures = 0
	w.insertsNoops = 0

	w.updatesAttempts = 0
	w.updatesFailures = 0
	w.updatesNoops = 0

	w.deletesAttempts = 0
	w.deletesFailures = 0
	w.deletesNoops = 0
}

func (w *WriteMetrics) String() string {
	return fmt.Sprintf(`WriteMetrics: inserts-deletes=%d, updates-deletes=%d,
insertsAttempts=%d, insertsFailures=%d, insertsNoops=%d, inserts=%d,
updatesAttempts=%d, updatesFailures=%d, updatesNoops=%d, updates=%d,
deletesAttempts=%d, deletesFailures=%d, deletesNoops=%d, deletes=%d,
`,
		w.inserts-w.deletes, w.updates-w.deletes,
		w.insertsAttempts, w.insertsFailures, w.insertsNoops, w.inserts,
		w.updatesAttempts, w.updatesFailures, w.updatesNoops, w.updates,
		w.deletesAttempts, w.deletesFailures, w.deletesNoops, w.deletes,
	)
}

var (
	clusterInstance *cluster.LocalProcessCluster
	shards          []cluster.Shard
	vtParams        mysql.ConnParams

	opOrder               int64
	opOrderMutex          sync.Mutex
	onlineDDLStrategy     = "vitess"
	hostname              = "localhost"
	keyspaceName          = "ks"
	cell                  = "zone1"
	schemaChangeDirectory = ""
	tableName             = `stress_test`
	cleanupStatements     = []string{
		`DROP TABLE IF EXISTS stress_test`,
	}
	createStatement = `
		CREATE TABLE stress_test (
			id bigint(20) not null,
			rand_val varchar(32) null default '',
			op_order bigint unsigned not null default 0,
			hint_col varchar(64) not null default '',
			created_timestamp timestamp not null default current_timestamp,
			updates int unsigned not null default 0,
			PRIMARY KEY (id),
			key created_idx(created_timestamp),
			key updates_idx(updates)
		) ENGINE=InnoDB
	`
	alterHintStatement = `
		ALTER TABLE stress_test modify hint_col varchar(64) not null default '%s'
	`
	insertRowStatement = `
		INSERT IGNORE INTO stress_test (id, rand_val, op_order) VALUES (%d, left(md5(rand()), 8), %d)
	`
	updateRowStatement = `
		UPDATE stress_test SET op_order=%d, updates=updates+1 WHERE id=%d
	`
	deleteRowStatement = `
		DELETE FROM stress_test WHERE id=%d AND updates=1
	`
	selectMaxOpOrder = `
		SELECT MAX(op_order) as m FROM stress_test
	`
	// We use CAST(SUM(updates) AS SIGNED) because SUM() returns a DECIMAL datatype, and we want to read a SIGNED INTEGER type
	selectCountRowsStatement = `
		SELECT COUNT(*) AS num_rows, CAST(SUM(updates) AS SIGNED) AS sum_updates FROM stress_test
	`
	truncateStatement = `
		TRUNCATE TABLE stress_test
	`
	writeMetrics WriteMetrics
)

var (
	countIterations = 5
)

const (
	maxTableRows         = 4096
	workloadDuration     = 5 * time.Second
	migrationWaitTimeout = 60 * time.Second
)

func resetOpOrder() {
	opOrderMutex.Lock()
	defer opOrderMutex.Unlock()
	opOrder = 0
}

func nextOpOrder() int64 {
	opOrderMutex.Lock()
	defer opOrderMutex.Unlock()
	opOrder++
	return opOrder
}

func TestMain(m *testing.M) {
	flag.Parse()

	exitcode, err := func() (int, error) {
		clusterInstance = cluster.NewCluster(cell, hostname)
		schemaChangeDirectory = path.Join("/tmp", fmt.Sprintf("schema_change_dir_%d", clusterInstance.GetAndReserveTabletUID()))
		defer os.RemoveAll(schemaChangeDirectory)
		defer clusterInstance.Teardown()

		if _, err := os.Stat(schemaChangeDirectory); os.IsNotExist(err) {
			_ = os.Mkdir(schemaChangeDirectory, 0700)
		}

		clusterInstance.VtctldExtraArgs = []string{
			"--schema_change_dir", schemaChangeDirectory,
			"--schema_change_controller", "local",
			"--schema_change_check_interval", "1s",
		}

		clusterInstance.VtTabletExtraArgs = []string{
			"--heartbeat_interval", "250ms",
			"--heartbeat_on_demand_duration", "5s",
			"--migration_check_interval", "5s",
			"--watch_replication_stream",
			// Test VPlayer batching mode.
			fmt.Sprintf("--vreplication_experimental_flags=%d",
				vttablet.VReplicationExperimentalFlagAllowNoBlobBinlogRowImage|vttablet.VReplicationExperimentalFlagOptimizeInserts|vttablet.VReplicationExperimentalFlagVPlayerBatching),
		}
		clusterInstance.VtGateExtraArgs = []string{
			"--ddl_strategy", "online",
		}

		if err := clusterInstance.StartTopo(); err != nil {
			return 1, err
		}

		// Start keyspace
		keyspace := &cluster.Keyspace{
			Name: keyspaceName,
		}

		// No need for replicas in this stress test
		if err := clusterInstance.StartKeyspace(*keyspace, []string{"1"}, 0, false); err != nil {
			return 1, err
		}

		vtgateInstance := clusterInstance.NewVtgateInstance()
		// Start vtgate
		if err := vtgateInstance.Setup(); err != nil {
			return 1, err
		}
		// ensure it is torn down during cluster TearDown
		clusterInstance.VtgateProcess = *vtgateInstance
		vtParams = mysql.ConnParams{
			Host: clusterInstance.Hostname,
			Port: clusterInstance.VtgateMySQLPort,
		}

		return m.Run(), nil
	}()
	if err != nil {
		fmt.Printf("%v\n", err)
		os.Exit(1)
	} else {
		os.Exit(exitcode)
	}

}

func TestVreplMiniStressSchemaChanges(t *testing.T) {

	ctx := context.Background()

	shards = clusterInstance.Keyspaces[0].Shards
	require.Equal(t, 1, len(shards))

	throttler.EnableLagThrottlerAndWaitForStatus(t, clusterInstance)

	t.Run("create schema", func(t *testing.T) {
		assert.Equal(t, 1, len(clusterInstance.Keyspaces[0].Shards))
		testWithInitialSchema(t)
	})
	for i := 0; i < countIterations; i++ {
		// This first tests the general functionality of initializing the table with data,
		// no concurrency involved. Just counting.
		testName := fmt.Sprintf("init table %d/%d", (i + 1), countIterations)
		t.Run(testName, func(t *testing.T) {
			initTable(t)
			testSelectTableMetrics(t)
		})
	}
	for i := 0; i < countIterations; i++ {
		// This tests running a workload on the table, then comparing expected metrics with
		// actual table metrics. All this without any ALTER TABLE: this is to validate
		// that our testing/metrics logic is sound in the first place.
		testName := fmt.Sprintf("workload without ALTER TABLE %d/%d", (i + 1), countIterations)
		t.Run(testName, func(t *testing.T) {
			initTable(t)

			ctx, cancel := context.WithTimeout(ctx, workloadDuration)
			defer cancel()

			var wg sync.WaitGroup
			wg.Add(1)
			go func() {
				defer wg.Done()
				runMultipleConnections(ctx, t)
			}()
			wg.Wait()
			testSelectTableMetrics(t)
		})
	}
	t.Run("ALTER TABLE without workload", func(t *testing.T) {
		// A single ALTER TABLE. Generally this is covered in endtoend/onlineddl_vrepl,
		// but we wish to verify the ALTER statement used in these tests is sound
		testWithInitialSchema(t)
		initTable(t)
		hint := "hint-alter-without-workload"
		uuid := testOnlineDDLStatement(t, fmt.Sprintf(alterHintStatement, hint), onlineDDLStrategy, "vtgate", hint)
		onlineddl.CheckMigrationStatus(t, &vtParams, shards, uuid, schema.OnlineDDLStatusComplete)
		testSelectTableMetrics(t)
	})

	for i := 0; i < countIterations; i++ {
		// Finally, this is the real test:
		// We populate a table, and begin a concurrent workload (this is the "mini stress")
		// We then ALTER TABLE via vreplication.
		// Once convinced ALTER TABLE is complete, we stop the workload.
		// We then compare expected metrics with table metrics. If they agree, then
		// the vreplication/ALTER TABLE did not corrupt our data and we are happy.
		testName := fmt.Sprintf("ALTER TABLE with workload %d/%d", (i + 1), countIterations)
		t.Run(testName, func(t *testing.T) {
			ctx := context.Background()
			t.Run("create schema", func(t *testing.T) {
				testWithInitialSchema(t)
			})
			t.Run("init table", func(t *testing.T) {
				initTable(t)
			})
			t.Run("migrate", func(t *testing.T) {
				ctx, cancel := context.WithCancel(ctx)
				defer cancel()

				var wg sync.WaitGroup
				wg.Add(1)
				go func() {
					defer wg.Done()
					runMultipleConnections(ctx, t)
				}()
				hint := fmt.Sprintf("hint-alter-with-workload-%d", i)
				uuid := testOnlineDDLStatement(t, fmt.Sprintf(alterHintStatement, hint), onlineDDLStrategy, "vtgate", hint)
				onlineddl.CheckMigrationStatus(t, &vtParams, shards, uuid, schema.OnlineDDLStatusComplete)
				cancel() // Now that the migration is complete, we can stop the workload.
				wg.Wait()
			})
			t.Run("validate metrics", func(t *testing.T) {
				testSelectTableMetrics(t)
			})
		})
	}

	t.Run("summary: validate sequential migration IDs", func(t *testing.T) {
		onlineddl.ValidateSequentialMigrationIDs(t, &vtParams, shards)
	})
}

func testWithInitialSchema(t *testing.T) {
	for _, statement := range cleanupStatements {
		err := clusterInstance.VtctldClientProcess.ApplySchema(keyspaceName, statement)
		require.Nil(t, err)
	}
	// Create the stress table
	err := clusterInstance.VtctldClientProcess.ApplySchema(keyspaceName, createStatement)
	require.Nil(t, err)

	// Check if table is created
	checkTable(t, tableName)
}

// testOnlineDDLStatement runs an online DDL, ALTER statement
func testOnlineDDLStatement(t *testing.T, alterStatement string, ddlStrategy string, executeStrategy string, expectHint string) (uuid string) {
	if executeStrategy == "vtgate" {
		row := onlineddl.VtgateExecDDL(t, &vtParams, ddlStrategy, alterStatement, "").Named().Row()
		if row != nil {
			uuid = row.AsString("uuid", "")
		}
	} else {
		var err error
		uuid, err = clusterInstance.VtctldClientProcess.ApplySchemaWithOutput(keyspaceName, alterStatement, cluster.ApplySchemaParams{DDLStrategy: ddlStrategy})
		assert.NoError(t, err)
	}
	uuid = strings.TrimSpace(uuid)
	fmt.Println("# Generated UUID (for debug purposes):")
	fmt.Printf("<%s>\n", uuid)

	strategySetting, err := schema.ParseDDLStrategy(ddlStrategy)
	assert.NoError(t, err)

	if !strategySetting.Strategy.IsDirect() {
		status := onlineddl.WaitForMigrationStatus(t, &vtParams, shards, uuid, migrationWaitTimeout, schema.OnlineDDLStatusComplete, schema.OnlineDDLStatusFailed)
		fmt.Printf("# Migration status (for debug purposes): <%s>\n", status)
	}

	if expectHint != "" {
		checkMigratedTable(t, tableName, expectHint)
	}
	return uuid
}

// checkTable checks the number of tables in the first two shards.
func checkTable(t *testing.T, showTableName string) {
	for i := range clusterInstance.Keyspaces[0].Shards {
		checkTablesCount(t, clusterInstance.Keyspaces[0].Shards[i].Vttablets[0], showTableName, 1)
	}
}

// checkTablesCount checks the number of tables in the given tablet
func checkTablesCount(t *testing.T, tablet *cluster.Vttablet, showTableName string, expectCount int) {
	query := fmt.Sprintf(`show tables like '%%%s%%';`, showTableName)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()

	rowcount := 0

	for {
		queryResult, err := tablet.VttabletProcess.QueryTablet(query, keyspaceName, true)
		require.Nil(t, err)
		rowcount = len(queryResult.Rows)
		if rowcount > 0 {
			break
		}

		select {
		case <-ticker.C:
			continue // Keep looping
		case <-ctx.Done():
			// Break below to the assertion
		}

		break
	}

	assert.Equal(t, expectCount, rowcount)
}

// checkMigratedTables checks the CREATE STATEMENT of a table after migration
func checkMigratedTable(t *testing.T, tableName, expectHint string) {
	for i := range clusterInstance.Keyspaces[0].Shards {
		createStatement := getCreateTableStatement(t, clusterInstance.Keyspaces[0].Shards[i].Vttablets[0], tableName)
		assert.Contains(t, createStatement, expectHint)
	}
}

// getCreateTableStatement returns the CREATE TABLE statement for a given table
func getCreateTableStatement(t *testing.T, tablet *cluster.Vttablet, tableName string) (statement string) {
	queryResult, err := tablet.VttabletProcess.QueryTablet(fmt.Sprintf("show create table %s;", tableName), keyspaceName, true)
	require.Nil(t, err)

	assert.Equal(t, len(queryResult.Rows), 1)
	assert.Equal(t, len(queryResult.Rows[0]), 2) // table name, create statement
	statement = queryResult.Rows[0][1].ToString()
	return statement
}

func generateInsert(t *testing.T, conn *mysql.Conn) error {
	id := rand.Int32N(int32(maxTableRows))
	query := fmt.Sprintf(insertRowStatement, id, nextOpOrder())
	qr, err := conn.ExecuteFetch(query, 1000, true)

	func() {
		writeMetrics.mu.Lock()
		defer writeMetrics.mu.Unlock()

		writeMetrics.insertsAttempts++
		if err != nil {
			writeMetrics.insertsFailures++
			return
		}
		assert.Less(t, qr.RowsAffected, uint64(2))
		if qr.RowsAffected == 0 {
			writeMetrics.insertsNoops++
			return
		}
		writeMetrics.inserts++
	}()
	return err
}

func generateUpdate(t *testing.T, conn *mysql.Conn) error {
	id := rand.Int32N(int32(maxTableRows))
	query := fmt.Sprintf(updateRowStatement, nextOpOrder(), id)
	qr, err := conn.ExecuteFetch(query, 1000, true)

	func() {
		writeMetrics.mu.Lock()
		defer writeMetrics.mu.Unlock()

		writeMetrics.updatesAttempts++
		if err != nil {
			writeMetrics.updatesFailures++
			return
		}
		assert.Less(t, qr.RowsAffected, uint64(2))
		if qr.RowsAffected == 0 {
			writeMetrics.updatesNoops++
			return
		}
		writeMetrics.updates++
	}()
	return err
}

func generateDelete(t *testing.T, conn *mysql.Conn) error {
	id := rand.Int32N(int32(maxTableRows))
	query := fmt.Sprintf(deleteRowStatement, id)
	qr, err := conn.ExecuteFetch(query, 1000, true)

	func() {
		writeMetrics.mu.Lock()
		defer writeMetrics.mu.Unlock()

		writeMetrics.deletesAttempts++
		if err != nil {
			writeMetrics.deletesFailures++
			return
		}
		assert.Less(t, qr.RowsAffected, uint64(2))
		if qr.RowsAffected == 0 {
			writeMetrics.deletesNoops++
			return
		}
		writeMetrics.deletes++
	}()
	return err
}

func runSingleConnection(ctx context.Context, t *testing.T, sleepInterval time.Duration) {
	log.Infof("Running single connection")
	conn, err := mysql.Connect(ctx, &vtParams)
	require.Nil(t, err)
	defer conn.Close()

	_, err = conn.ExecuteFetch("set autocommit=1", 1000, true)
	require.Nil(t, err)
	_, err = conn.ExecuteFetch("set transaction isolation level read committed", 1000, true)
	require.Nil(t, err)

	ticker := time.NewTicker(sleepInterval)
	defer ticker.Stop()

	for {
		switch rand.Int32N(3) {
		case 0:
			err = generateInsert(t, conn)
		case 1:
			err = generateUpdate(t, conn)
		case 2:
			err = generateDelete(t, conn)
		}
		select {
		case <-ctx.Done():
			log.Infof("Terminating single connection")
			return
		case <-ticker.C:
		}
		assert.Nil(t, err)
	}
}

func runMultipleConnections(ctx context.Context, t *testing.T) {
	// The workload for a 16 vCPU machine is:
	// - Concurrency of 16
	// - 2ms interval between queries for each connection
	// As the number of vCPUs decreases, so do we decrease concurrency, and increase intervals. For example, on a 8 vCPU machine
	// we run concurrency of 8 and interval of 4ms. On a 4 vCPU machine we run concurrency of 4 and interval of 8ms.
	maxConcurrency := runtime.NumCPU()
	sleepModifier := 16.0 / float64(maxConcurrency)
	baseSleepInterval := 2 * time.Millisecond
	singleConnectionSleepIntervalNanoseconds := float64(baseSleepInterval.Nanoseconds()) * sleepModifier
	sleepInterval := time.Duration(int64(singleConnectionSleepIntervalNanoseconds))

	log.Infof("Running multiple connections: maxConcurrency=%v, sleep interval=%v", maxConcurrency, sleepInterval)
	var wg sync.WaitGroup
	for i := 0; i < maxConcurrency; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			runSingleConnection(ctx, t, sleepInterval)
		}()
	}
	wg.Wait()
	log.Infof("Running multiple connections: done")
}

func initTable(t *testing.T) {
	log.Infof("initTable begin")
	defer log.Infof("initTable complete")

	t.Run("cancel pending migrations", func(t *testing.T) {
		cancelQuery := "alter vitess_migration cancel all"
		r := onlineddl.VtgateExecQuery(t, &vtParams, cancelQuery, "")
		if r.RowsAffected > 0 {
			fmt.Printf("# Cancelled migrations (for debug purposes): %d\n", r.RowsAffected)
		}
	})

	ctx := context.Background()
	conn, err := mysql.Connect(ctx, &vtParams)
	require.Nil(t, err)
	defer conn.Close()

	resetOpOrder()
	writeMetrics.Clear()
	_, err = conn.ExecuteFetch(truncateStatement, 1000, true)
	require.Nil(t, err)

	for i := 0; i < maxTableRows/2; i++ {
		generateInsert(t, conn)
	}
	for i := 0; i < maxTableRows/4; i++ {
		generateUpdate(t, conn)
	}
	for i := 0; i < maxTableRows/4; i++ {
		generateDelete(t, conn)
	}
}

func testSelectTableMetrics(t *testing.T) {
	writeMetrics.mu.Lock()
	defer writeMetrics.mu.Unlock()

	{
		rs := onlineddl.VtgateExecQuery(t, &vtParams, selectMaxOpOrder, "")
		row := rs.Named().Row()
		require.NotNil(t, row)

		maxOpOrder := row.AsInt64("m", 0)
		fmt.Printf("# max op_order in table: %d\n", maxOpOrder)
	}

	log.Infof("%s", writeMetrics.String())

	ctx := context.Background()
	conn, err := mysql.Connect(ctx, &vtParams)
	require.Nil(t, err)
	defer conn.Close()

	rs, err := conn.ExecuteFetch(selectCountRowsStatement, 1000, true)
	require.Nil(t, err)

	row := rs.Named().Row()
	require.NotNil(t, row)
	log.Infof("testSelectTableMetrics, row: %v", row)
	numRows := row.AsInt64("num_rows", 0)
	sumUpdates := row.AsInt64("sum_updates", 0)
	assert.NotZero(t, numRows)
	assert.NotZero(t, sumUpdates)
	assert.NotZero(t, writeMetrics.inserts)
	assert.NotZero(t, writeMetrics.deletes)
	assert.NotZero(t, writeMetrics.updates)
	assert.Equal(t, writeMetrics.inserts-writeMetrics.deletes, numRows)
	assert.Equal(t, writeMetrics.updates-writeMetrics.deletes, sumUpdates) // because we DELETE WHERE updates=1
}
