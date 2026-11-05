D=$PWD/rtmp; rm -rf $D; mkdir $D
for n in pub sub; do
  initdb -D $D/$n >/dev/null
  p=$([ $n = pub ] && echo 5441 || echo 5442)
  pg_ctl -D $D/$n -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$D -c port=$p" -l $D/$n.log -w start >/dev/null
done
P="psql -X -q -h $D -d postgres"
$P -p 5441 -c "CREATE TABLE t(a int primary key, b text)" -c "INSERT INTO t VALUES (1,'foo')" -c "CREATE PUBLICATION pb FOR TABLE t"
$P -p 5442 -c "CREATE TABLE t(a int primary key, b text, d bigint DEFAULT 999)"
$P -p 5442 -c "CREATE SUBSCRIPTION s CONNECTION 'host=$D port=5441 dbname=postgres' PUBLICATION pb"
for i in $(seq 100); do
  [ "$($P -p 5442 -Atc "select count(*) from t")" = 1 ] && break; sleep 0.3
done
$P -p 5441 -c "UPDATE t SET b='bar'"
for i in $(seq 100); do
  [ "$($P -p 5442 -Atc "select b from t")" = bar ] && break; sleep 0.3
done
$P -p 5442 -c "SELECT a,b,d FROM t"
$P -p 5442 -c "DROP SUBSCRIPTION s"
for n in sub pub; do pg_ctl -D $D/$n -m fast stop >/dev/null; done
rm -rf $D
