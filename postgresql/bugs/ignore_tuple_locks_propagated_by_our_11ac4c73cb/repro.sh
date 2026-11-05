psql -X -q -c "create table parent (i int primary key, c char(3)); insert into parent values (1,'AAA'); create table child (i int references parent(i));"
psql -X -q -c "begin; insert into child values (1); select pg_sleep(3); commit;" >/dev/null &
sleep 1
psql -X -a -q <<'SQL'
begin;
update parent set c = lower(c);
delete from parent;
commit;
SQL
wait
psql -X -q -c "select (select count(*) from parent) p, (select count(*) from child) c"
