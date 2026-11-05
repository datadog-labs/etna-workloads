psql -X -q -c "create table t (a int, b int generated always as (a*2) stored); insert into t values (1);"
( psql -X -q -c "begin; update t set a = a + 10; select pg_sleep(3); commit;" >/dev/null ) &
sleep 1
psql -X -q -c "update t set a = a + 100"
wait
psql -X -c "select * from t"
