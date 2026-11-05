psql -X -q -c 'create table t as select g x from generate_series(1,100) g' \
 -c 'create index "q""s'"'"'x" on t(x,(x-1))' -c 'analyze t'
pg_dump -d postgres --no-data --statistics 2>&1 | grep -E "relname|ERROR|error" | grep -v "'t'"
