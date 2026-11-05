psql -X -q -c "CREATE TABLE t3 (f1 int, junk int, g1 int generated always as (f1*2) stored, f3 int, g2 int generated always as (f3*3) stored); ALTER TABLE t3 DROP COLUMN junk; INSERT INTO t3 VALUES (123, DEFAULT, 456);"
pg_dump --no-sync -a --inserts -t t3 postgres | grep '^INSERT'
psql -X -q -c "DROP TABLE t3"
