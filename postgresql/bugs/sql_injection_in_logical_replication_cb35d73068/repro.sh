D=$PWD/tmp_c; rm -rf $D; mkdir -p $D
initdb -D $D/d -A trust >/dev/null 2>&1
echo "wal_level=logical
listen_addresses=''
unix_socket_directories='$D'
port=54399" >> $D/d/postgresql.conf
pg_ctl -D $D/d -l $D/log -w start >/dev/null
P="psql -X -q -h $D -p 54399"
$P -d postgres -c "create database pub" -c "create database sub"
$P -d pub -c "create table \"tab'le\" (a int primary key)" -c "create table t2 (a int primary key)" -c "create publication p for table \"tab'le\"" -c "select pg_create_logical_replication_slot('s','pgoutput') is not null"
$P -d sub -c "create table \"tab'le\" (a int primary key)" -c "create table t2 (a int primary key)"
$P -d sub -c "create subscription s connection 'host=$D port=54399 dbname=pub' publication p with (origin=none, copy_data=false, create_slot=false, slot_name='s')"
$P -d pub -c "alter publication p add table t2"
$P -d sub -c "alter subscription s refresh publication with (copy_data=true)" 2>&1 | sed 's/[0-9]\{3,\}/N/g'
$P -d sub -c "drop subscription s" >/dev/null 2>&1
pg_ctl -D $D/d -m immediate stop >/dev/null
rm -rf $D
