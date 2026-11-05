D=$PWD/rtmp; rm -rf $D; mkdir $D
initdb -D $D/pub >/dev/null 2>&1; initdb -D $D/sub >/dev/null 2>&1
pg_ctl -D $D/pub -o "-c wal_level=logical -c listen_addresses='' -k $D -p 5601" -l $D/pub.log -w start >/dev/null
pg_ctl -D $D/sub -o "-c listen_addresses='' -k $D -p 5602" -l $D/sub.log -w start >/dev/null
P="psql -X -q -h $D -p 5601 postgres"; S="psql -X -q -h $D -p 5602 postgres"
$P -c "create table t(a int primary key, b text); alter table t replica identity full; create publication pb for table t; insert into t values (1,'foo')"
$S -c "create table t(a int primary key, b text); alter table t replica identity full"
$S -c "create subscription sb connection 'host=$D port=5601 dbname=postgres' publication pb"
sleep 4
$P -c "update t set b='bar' where a=1"
sleep 4
$S -Atc "select * from t"
$S -c "drop subscription sb" >/dev/null 2>&1
pg_ctl -D $D/sub -m immediate stop >/dev/null; pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
