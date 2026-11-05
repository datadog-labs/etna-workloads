D=$PWD/tmp_cluster
rm -rf $D
initdb -D $D -A trust >/dev/null 2>&1
unset PGPORT PGHOST
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$D -c port=5499 -c wal_retrieve_retry_interval=100ms" -w -l $D/log start >/dev/null 2>&1
export PGHOST=$D PGPORT=5499
P="psql -X -q"
$P -d postgres -c "create database pub" -c "create database sub"
$P -d pub -c "create table t(a int primary key, b int)" -c "create publication p for table t" -c "select pg_create_logical_replication_slot('s','pgoutput')" >/dev/null
$P -d sub -c "create table t(a int, b int) partition by list (a)" -c "create table t1 partition of t (primary key (a)) for values in (1,2)"
$P -d sub -c "create subscription s connection 'host=$D port=5499 dbname=pub' publication p with (create_slot=false, slot_name='s', copy_data=false)"
$P -d pub -c "insert into t values (1,1)"
$P -d sub -c "select pg_sleep(2)" >/dev/null
$P -d pub -c "update t set b = 2 where a = 1"
$P -d sub -c "select pg_sleep(2)" >/dev/null
echo "rows in t1 on subscriber:"
$P -d sub -At -c "select * from t1"
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D
