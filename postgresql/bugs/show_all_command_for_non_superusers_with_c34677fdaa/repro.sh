psql -X -q -d postgres -c "CREATE ROLE repl_role REPLICATION LOGIN; GRANT pg_read_all_settings TO repl_role;"
psql -X -q "host=$PGHOST port=$PGPORT user=repl_role replication=database dbname=postgres" -c "SHOW primary_conninfo;" >/dev/null 2>&1
echo "show exit: $?"
psql -X -q -d postgres -c "SELECT 1 AS alive;"
