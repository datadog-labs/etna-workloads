psql -X -q -c "SELECT pg_create_logical_replication_slot('test_slot','test_decoding')" -c "ALTER SYSTEM SET wal_level='logical'" >/dev/null 2>&1
psql -X -At -d "dbname=template1 replication=database" -c "START_REPLICATION SLOT test_slot LOGICAL 0/0" 2>&1 | grep -o 'was not created in this database'
sleep 1
psql -X -At -c "select 'alive'" 2>&1 | tail -1
