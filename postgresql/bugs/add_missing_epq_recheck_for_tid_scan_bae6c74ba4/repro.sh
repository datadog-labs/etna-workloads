psql -X -q -c "drop table if exists t; create table t(id int, b int); insert into t values (1,100); insert into t values (2,200);"
( psql -X -q -At <<SQL
begin;
update t set b=b+1 where ctid='(0,1)';
select pg_sleep(3);
commit;
SQL
) &
sleep 1
psql -X -q -At -c "set enable_seqscan=off; update t set b=b+1000 where ctid='(0,1)' returning id,b;" > s2.out &
wait
echo "s2 result:"; cat s2.out
psql -X -At -c "select * from t order by id"
