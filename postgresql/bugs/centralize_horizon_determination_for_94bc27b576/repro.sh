(psql -X -q -c "begin isolation level repeatable read; select count(*) from pg_class; select pg_sleep(8);" >/dev/null 2>&1 &)
sleep 1
psql -X -a -q <<'SQL'
create temp table t(a int);
insert into t select generate_series(1,10);
delete from t;
vacuum t;
select pg_relation_size('t') as size;
SQL
sleep 8
