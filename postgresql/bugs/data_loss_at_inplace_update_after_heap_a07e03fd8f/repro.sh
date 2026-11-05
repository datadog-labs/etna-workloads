psql -X -q -c "drop table if exists t; create table t(a int); grant select on t to public;" 
( psql -X -q -c "begin; grant insert on t to public; select pg_sleep(4); commit;" >/dev/null 2>&1 ) &
sleep 1
( psql -X -q -c "vacuum t" >/dev/null 2>&1; touch vac_done.$$ ) &
sleep 2
if ls vac_done.* >/dev/null 2>&1; then echo "vacuum not blocked"; else echo "vacuum blocked"; fi
wait
rm -f vac_done.*
