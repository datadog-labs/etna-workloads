D=$PWD/rdata
S=$PWD/rsock
rm -rf $D $S; mkdir $S
initdb -D $D -A trust >/dev/null 2>&1
pg_ctl -D $D -o "-c wal_level=logical -c listen_addresses='' -c unix_socket_directories=$S -c port=54329" -w -l $D/log start >/dev/null 2>&1
psql -X -q -h $S -p 54329 -d "dbname=postgres replication=database" >/dev/null 2>&1 <<'SQL'
CREATE_REPLICATION_SLOT test_slot LOGICAL pgoutput (SNAPSHOT export);
DROP_REPLICATION_SLOT test_slot;
SQL
echo "exit=$?"
psql -X -h $S -p 54329 -d postgres -Atc "select count(*) from pg_replication_slots" 2>&1 | head -3
pg_ctl -D $D -m immediate stop >/dev/null 2>&1
rm -rf $D $S
