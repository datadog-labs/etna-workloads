B=$PWD/rtmp; rm -rf $B; mkdir -p $B
for n in pub sub; do
  initdb -D $B/$n >/dev/null 2>&1
  echo "wal_level=logical
listen_addresses=''
unix_socket_directories='$B'
port=$([ $n = pub ] && echo 5481 || echo 5482)" >> $B/$n/postgresql.conf
  pg_ctl -D $B/$n -l $B/$n.log -w start >/dev/null
done
P="psql -X -q -h $B -p 5481 -d postgres"; S="psql -X -q -h $B -p 5482 -d postgres"
$P -c "create table t(x text); insert into t values ('a'),('b'),('b'); create publication pb for table t; alter table t replica identity full"
$S -c "create table t(x text)"
$S -c "create subscription sb connection 'host=$B port=5481 dbname=postgres' publication pb"
sleep 4
$P -c "delete from t where x='a'; update t set x='c' where x='b'"
sleep 4
$S -c "select * from t order by x"
$S -c "drop subscription sb" >/dev/null 2>&1
for n in pub sub; do pg_ctl -D $B/$n -m immediate stop >/dev/null; done
rm -rf $B
