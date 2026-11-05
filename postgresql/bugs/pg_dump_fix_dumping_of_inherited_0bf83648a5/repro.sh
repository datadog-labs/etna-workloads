psql -X -q -c "create table gp (a int primary key, b int generated always as (a*2) stored); create table gc (a int, b int) inherits (gp);"
pg_dump --schema-only | grep -A5 'CREATE TABLE public.gc'
psql -X -q -c "drop table gc, gp"
