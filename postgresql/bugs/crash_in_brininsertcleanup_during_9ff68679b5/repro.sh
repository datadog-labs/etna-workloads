D=$PWD/rtmp; rm -rf $D; mkdir -p $D
export PGHOST=$D
initdb -D $D/pub -A trust >/dev/null; initdb -D $D/sub -A trust >/dev/null
pg_ctl -D $D/pub -o "-c wal_level=logical -c port=5601 -c unix_socket_directories=$D -c listen_addresses=''" -w -l $D/pub.log start >/dev/null
pg_ctl -D $D/sub -o "-c port=5602 -c unix_socket_directories=$D -c listen_addresses='' -c restart_after_crash=off" -w -l $D/sub.log start >/dev/null
P="psql -X -q -At -p 5601 postgres"; S="psql -X -q -At -p 5602 postgres"
$P -c "create table t(a int, b int)" -c "insert into t values (1,1)" -c "create publication p for table t"
$S -c "create table t(a int, b int) partition by range(a)" -c "create table t1 partition of t for values from (0) to (100)" -c "create index on t using brin(b)"
$S -c "create subscription s connection 'host=$D port=5601 dbname=postgres' publication p" >/dev/null 2>&1
for i in $(seq 30); do [ "$($S -c 'select count(*) from t' 2>/dev/null)" = 1 ] && break; sleep 1; done
$P -c "insert into t values (2,2)"
sleep 3
R=$($S -c "select count(*) from t" 2>/dev/null) || R="server down"
echo "rows on subscriber: $R"
$S -c "drop subscription s" >/dev/null 2>&1
pg_ctl -D $D/sub -m immediate stop >/dev/null 2>&1; pg_ctl -D $D/pub -m immediate stop >/dev/null 2>&1
