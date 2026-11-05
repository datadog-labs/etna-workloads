psql -X -q -c "drop table if exists p cascade" -c "create table p (a int, b int, c int)" \
 -c "create table c1 () inherits (p)" -c "create table c2 () inherits (p)" -c "create table c3 () inherits (p)" \
 -c "insert into c1 select 0, a/3, a%3 from generate_series(0,9) a" \
 -c "insert into c2 select 1, a/3, a%3 from generate_series(0,9) a" \
 -c "insert into c3 select 2, a/3, a%3 from generate_series(0,9) a"
psql -X -q -c "begin" -c "update p set c = 4 where c = 0" -c "select pg_sleep(3)" -c "commit" >/dev/null &
sleep 1
psql -X -q -c "update p set b = -4 where c = 0"
wait
psql -X -c "select tableoid::regclass, a, b, c from p where c = 4 order by 1, 2, 3"
