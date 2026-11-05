psql -X -q -c "create table jointest as select g as id, 0 as data from generate_series(1,10) g" -c "create index on jointest(id)" -c "analyze jointest"
psql -X -q -o /dev/null <<'S1' &
begin;
update jointest set data = 42 where id = 7;
select pg_sleep(2);
commit;
S1
sleep 1
psql -X -a -q <<'S2'
set enable_hashjoin=0; set enable_nestloop=0; set enable_seqscan=0; set enable_bitmapscan=0; set enable_sort=0; set enable_material=0;
explain (costs off) select * from jointest a join jointest b on a.id=b.id for update;
select * from jointest a join jointest b on a.id=b.id for update;
S2
wait
