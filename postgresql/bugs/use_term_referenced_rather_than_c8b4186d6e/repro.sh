psql -X -q -c "CREATE SCHEMA testschema"
psql -X -q -c "BEGIN; DROP SCHEMA testschema; SELECT pg_sleep(3); COMMIT" >/dev/null &
sleep 1
psql -X -q -c "CREATE FUNCTION testschema.foo() RETURNS int AS 'select 1' LANGUAGE sql" 2>&1
wait
