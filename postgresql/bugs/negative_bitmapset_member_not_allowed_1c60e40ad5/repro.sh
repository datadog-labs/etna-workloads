D=$PWD/rtmp; rm -rf $D; mkdir -p $D
unset PGHOST PGPORT PGDATABASE
export PGHOST=$D
initdb -D $D/pub >/dev/null 2>&1; initdb -D $D/sub >/dev/null 2>&1
pg_ctl -D $D/pub -o "-c wal_level=logical -c port=54401 -c unix_socket_directories=$D -c listen_addresses=''" -l $D/pub.log -w start >/dev/null
pg_ctl -D $D/sub -o "-c port=54402 -c unix_socket_directories=$D -c listen_addresses='' -c wal_retrieve_retry_interval=100" -l $D/sub.log -w start >/dev/null
P="psql -X -q -At -p 54401 postgres"; S="psql -X -q -At -p 54402 postgres"
$P -c "CREATE TABLE t2 (a int)"; $P -c "CREATE PUBLICATION pb FOR ALL TABLES"
$S -c "CREATE TABLE t2 (a int)"
$S -c "CREATE SUBSCRIPTION sb CONNECTION 'host=$D port=54401 dbname=postgres' PUBLICATION pb"
sleep 3
$S -c "ALTER SUBSCRIPTION sb REFRESH PUBLICATION"
$S -c "ALTER TABLE t2 ADD COLUMN b serial PRIMARY KEY"
$P -c "INSERT INTO t2 VALUES (1)"
sleep 6
$S -c "SELECT count(*), min(a), max(a) FROM t2"
$S -c "DROP SUBSCRIPTION sb" >/dev/null 2>&1
pg_ctl -D $D/sub -m immediate stop >/dev/null; pg_ctl -D $D/pub -m immediate stop >/dev/null
rm -rf $D
