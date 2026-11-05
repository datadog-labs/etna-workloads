psql -X -q -c "drop table if exists acc" -c "create table acc(id text, bal int)" -c "insert into acc values ('checking',600),('savings',600)"
(
echo "begin;"
echo "update acc set bal=bal+100 where ctid between '(0,1)' and '(0,1)' returning id,bal;"
# wait until session 2 is blocked on our row lock
while [ "$(psql -X -At -c "select count(*) from pg_stat_activity where wait_event_type='Lock' and query like '%bal+200%'")" != 1 ]; do sleep 0.1; done
echo "commit;"
) | psql -X -q -a > s1.out 2>&1 &
sleep 1
psql -X -a -c "update acc set bal=bal+200 where ctid between '(0,1)' and '(0,1)' returning id,bal;"
wait
cat s1.out
psql -X -c "select * from acc order by id"
