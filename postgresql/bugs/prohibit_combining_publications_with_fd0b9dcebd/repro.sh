D=$PWD/rtmp_data; S=$PWD/rtmp_sock
rm -rf $D $S; mkdir -p $S
initdb -D $D >/dev/null 2>&1
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$S -c port=5599" -w -l $PWD/rtmp.log start >/dev/null
export PGHOST=$S PGPORT=5599
psql -X -a -q postgres <<'SQL'
CREATE TABLE t(a int, b int, c int);
CREATE PUBLICATION p1 FOR TABLE t(a);
CREATE PUBLICATION p2 FOR TABLE t(a,b);
SELECT pg_create_logical_replication_slot('s1','pgoutput') IS NOT NULL;
SQL
psql -X -a -q postgres -c "CREATE SUBSCRIPTION sub CONNECTION 'host=$S port=5599 dbname=postgres' PUBLICATION p1, p2 WITH (create_slot=false, slot_name='s1', enabled=false)" 2>&1 | sed 's/^psql:[^ ]* //'
psql -X -q postgres -Atc "select count(*) from pg_subscription"
pg_ctl -D $D -m immediate stop >/dev/null
rm -rf $D $S
