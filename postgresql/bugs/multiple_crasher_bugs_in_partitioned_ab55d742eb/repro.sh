set -e
D=$PWD/rpl_tmp
rm -rf $D; mkdir -p $D
S=$D/sock
mkdir -p $S
initdb -D $D/pub >/dev/null 2>&1
initdb -D $D/sub >/dev/null 2>&1
pg_ctl -D $D/pub -o "-c wal_level=logical -c port=5601 -c unix_socket_directories=$S -c listen_addresses=''" -l $D/pub.log -w start >/dev/null
pg_ctl -D $D/sub -o "-c port=5602 -c unix_socket_directories=$S -c listen_addresses=''" -l $D/sub.log -w start >/dev/null
P="psql -X -q -h $S -p 5601 postgres"
B="psql -X -q -h $S -p 5602 postgres"
$P -c "create table t(a int primary key, b text) partition by list (a); create table t1 partition of t for values in (1,2,3,4,5,6); create table t2 partition of t default; create publication p for table t;"
$B -c "create table t1(a int primary key, b text) partition by list (a); create table t1_1 (b text, a int not null); alter table t1 attach partition t1_1 for values in (1,2,3); create table t1_2 partition of t1 for values in (4,5,6); create table t2(a int primary key, b text);"
$B -c "create subscription s connection 'host=$S port=5601 dbname=postgres' publication p;"
sleep 3
$P -c "insert into t values (1,'a'),(4,'d'),(10,'j')"
sleep 2
$P -c "update t set b = 'x' where a in (1,4)"
$P -c "delete from t where a = 1"
sleep 2
$B -c "alter table t1_2 set (fillfactor=80)"
$P -c "insert into t values (3,'c')"
sleep 2
$B -c "alter table t1 replica identity using index t1_pkey"
$P -c "insert into t values (6,'f')"
sleep 2
$P -c "truncate t1"
sleep 2
$P -c "insert into t values (2,'b'),(5,'e')"
sleep 2
$P -c "update t set b = 'y' where a in (2,5)"
$P -c "delete from t where a = 4"
sleep 3
$B -c "select a, b from t1 order by a" || echo "sub query failed"
grep -c "terminating any other active server processes" $D/sub.log || true
pg_ctl -D $D/sub -m immediate stop >/dev/null 2>&1 || true
pg_ctl -D $D/pub -m immediate stop >/dev/null 2>&1 || true
rm -rf $D
