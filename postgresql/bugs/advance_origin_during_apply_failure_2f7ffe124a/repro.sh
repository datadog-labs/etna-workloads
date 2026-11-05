D=$PWD/rt_$$
mkdir -p $D
export PGHOST=$D PGDATABASE=postgres
PUB=5601; SUB=5602
initdb -D $D/pub >/dev/null; initdb -D $D/sub >/dev/null
cat >> $D/pub/postgresql.conf <<C
wal_level=logical
max_prepared_transactions=10
debug_logical_replication_streaming=immediate
port=$PUB
unix_socket_directories='$D'
listen_addresses=''
C
cat >> $D/sub/postgresql.conf <<C
max_prepared_transactions=0
debug_logical_replication_streaming=buffered
max_logical_replication_workers=10
port=$SUB
unix_socket_directories='$D'
listen_addresses=''
C
pg_ctl -D $D/pub -w -l $D/pub.log start >/dev/null
pg_ctl -D $D/sub -w -l $D/sub.log start >/dev/null
psql -X -q -p $PUB -c "create table t(a int primary key); create publication p for table t;"
psql -X -q -p $SUB -c "create table t(a int primary key);"
psql -X -q -p $SUB -c "create subscription s connection 'host=$D port=$PUB dbname=postgres' publication p with (streaming=parallel, two_phase=true, copy_data=false)"
sleep 3
psql -X -q -p $PUB <<'S'
begin; insert into t values (2); prepare transaction 'x'; commit prepared 'x';
S
sleep 6
pg_ctl -D $D/sub -w -m fast stop >/dev/null
sed -i 's/max_prepared_transactions=0/max_prepared_transactions=10/' $D/sub/postgresql.conf
pg_ctl -D $D/sub -w -l $D/sub.log start >/dev/null
sleep 6
psql -X -q -p $SUB -c "select * from t order by 1"
pg_ctl -D $D/sub -m immediate stop >/dev/null
pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
