D=$PWD/rtmp_$$
export PGHOST=$D PGPORT=54399
mkdir -p $D
initdb -D $D/data >/dev/null 2>&1
cat >> $D/data/postgresql.conf <<C
wal_level=logical
listen_addresses=''
unix_socket_directories='$D'
port=54399
C
pg_ctl -D $D/data -w -l $D/log start >/dev/null 2>&1
psql -X -q -c "create table t(f int)" -c "create table t2(f int)" postgres
psql -X -q -c "create database d2" postgres
psql -X -q -d d2 -c "create table t(f int)" -c "create table t2(f int)"
psql -X -q <<S postgres
insert into t select generate_series(1,3000);
insert into t2 select generate_series(1,3000);
create publication p for table t;
select pg_create_logical_replication_slot('s','pgoutput') is not null;
S
psql -X -q -d d2 -c "create subscription sb connection 'host=$D port=54399 dbname=postgres' publication p with (create_slot=false, slot_name='s')"
psql -X -q postgres -c "insert into t select generate_series(1,3000)" -c "insert into t2 select generate_series(1,3000)" -c "alter publication p add table t2"
psql -X -q -d d2 -c "alter subscription sb refresh publication"
i=0
while [ $i -lt 40 ]; do
  n=$(psql -X -At -d d2 -c "select count(*) from pg_subscription_rel where srsubstate not in ('r','s')")
  [ "$n" = 0 ] && break
  i=$((i+1)); sleep 1
done
sleep 2
echo "not ready: $n"
psql -X -At -d d2 -c "select count(*) from t" -c "select count(*) from t2"
psql -X -q -d d2 -c "drop subscription sb" >/dev/null 2>&1
pg_ctl -D $D/data -m immediate stop >/dev/null 2>&1
rm -rf $D
