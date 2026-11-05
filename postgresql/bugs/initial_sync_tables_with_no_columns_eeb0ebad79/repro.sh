psql -X -q -c "ALTER SYSTEM SET wal_level=logical" 
pg_ctl -w -t 60 -l "$PGDATA/log2" restart >/dev/null
psql -X -q -c "CREATE TABLE tab_no_col()" -c "INSERT INTO tab_no_col DEFAULT VALUES" -c "CREATE PUBLICATION p FOR TABLE tab_no_col"
psql -X -q -At -c "SELECT pg_create_logical_replication_slot('s','pgoutput') IS NOT NULL"
psql -X -q -c "CREATE DATABASE sub"
psql -X -q -d sub -c "CREATE TABLE tab_no_col()"
psql -X -q -d sub -c "CREATE SUBSCRIPTION sb CONNECTION 'host=$PGHOST port=$PGPORT dbname=postgres' PUBLICATION p WITH (create_slot=false, slot_name='s')" 2>&1
for i in $(seq 1 20); do
  n=$(psql -X -At -d sub -c "SELECT count(*) FROM pg_subscription_rel WHERE srsubstate NOT IN ('r','s')")
  [ "$n" = 0 ] && break; sleep 1
done
echo "unsynced: $n"
psql -X -At -d sub -c "SELECT count(*) FROM tab_no_col"
