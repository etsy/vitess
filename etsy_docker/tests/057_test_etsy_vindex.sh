#!/bin/bash

# insert legacy sharded entries
mysql -h mysqld -P 3307 -uroot -pfoobar -D etsy_failover_shard_001_0_A -e 'insert ignore into vitess_etet (id, f_varchar, create_date, update_date) values (1, "a", 0, 0)'
mysql -h mysqld -P 3307 -uroot -pfoobar -D etsy_failover_shard_001_0_A -e 'insert ignore into vitess_etet (id, f_varchar, create_date, update_date) values (2, "b", 0, 0)'
mysql -h mysqld -P 3307 -uroot -pfoobar -D etsy_failover_shard_001_0_A -e 'insert ignore into vitess_etet (id, f_varchar, create_date, update_date) values (3, "c", 0, 0)'

# insert new records via vindex
mysql -h vtgate -P 15307 -u test-rw -ptest -BN -e 'set workload="OLTP"; insert ignore into etsy_failover_shard.vitess_etet (id, f_varchar, create_date, update_date) values (4, "d", 0, 0)'
mysql -h vtgate -P 15307 -u test-rw -ptest -BN -e 'set workload="OLTP"; insert ignore into etsy_failover_shard.vitess_etet (id, f_varchar, create_date, update_date) values (5, "e", 0, 0)'
mysql -h vtgate -P 15307 -u test-rw -ptest -BN -e 'set workload="OLTP"; insert ignore into etsy_failover_shard.vitess_etet (id, f_varchar, create_date, update_date) values (6, "f", 0, 0)'

# select legacy and new records via vindex
val1=$(mysql -h vtgate -P 15307 -u test-rw -ptest -D etsy_failover_shard -BN -e 'select f_varchar from vitess_etet where id = 1')
val2=$(mysql -h vtgate -P 15307 -u test-rw -ptest -D etsy_failover_shard -BN -e 'select f_varchar from vitess_etet where id = 2')
val3=$(mysql -h vtgate -P 15307 -u test-rw -ptest -D etsy_failover_shard -BN -e 'select f_varchar from vitess_etet where id = 3')
val4=$(mysql -h vtgate -P 15307 -u test-rw -ptest -D etsy_failover_shard -BN -e 'select f_varchar from vitess_etet where id = 4')
val5=$(mysql -h vtgate -P 15307 -u test-rw -ptest -D etsy_failover_shard -BN -e 'select f_varchar from vitess_etet where id = 5')
val6=$(mysql -h vtgate -P 15307 -u test-rw -ptest -D etsy_failover_shard -BN -e 'select f_varchar from vitess_etet where id = 6')

observed="$val1:$val2:$val3:$val4:$val5:$val6"
expected="a:b:c:d:e:f"

if [ "$observed" = "$expected" ]; then
    echo "PASS: Got correct values"
    exit 0
else
    echo "FAIL: Did not get correct values; wanted $expected saw $observed"
    exit 1
fi
