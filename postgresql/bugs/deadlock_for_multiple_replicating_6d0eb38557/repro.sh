D=$PWD/tmp_pub; rm -rf $D; mkdir -p $D
initdb -D $D/d >/dev/null 2>&1
echo "wal_level=logical
listen_addresses=''
unix_socket_directories='$D'
port=54399" >> $D/d/postgresql.conf
pg_ctl -D $D/d -l $D/log -w start >/dev/null
P="psql -X -q -At -h $D -p 54399"
$P -d postgres -c "create database sub" 
$P -d postgres -c "create table t(a int)"; $P -d postgres -c "create publication p for table t"; $P -d postgres -c "
select pg_create_logical_replication_slot('s1','pgoutput') is not null" >/dev/null
$P -d sub -c "create table t(a int)"; $P -d sub -c "create subscription s1 connection 'host=$D port=54399 dbname=postgres' publication p with (copy_data=false, create_slot=false, slot_name='s1');"  2>&1 | grep -v NOTICE
$P -d postgres -c "insert into t values (1),(2),(3)"
sleep 2
$P -d sub -c "select count(*) from t"
# hold ROW EXCLUSIVE lock on subscriber table
( echo "begin; lock table t in row exclusive mode; select pg_sleep(6); commit;" | $P -d sub >/dev/null ) &
sleep 1
$P -d postgres -c "truncate t"
sleep 2
$P -d sub -c "select count(*) from t" 
$P -d sub -c "select count(*) from pg_locks l where relation='t'::regclass and mode='AccessExclusiveLock' and not granted"
wait
pg_ctl -D $D/d -m immediate stop >/dev/null
rm -rf $D
