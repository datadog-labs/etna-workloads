psql -X -q -c "create table p(a int); insert into p values(1); create table c1() inherits(p); insert into c1 values(10);"
(echo "begin; alter table c1 no inherit p;"; sleep 3; echo "commit;") | psql -X -q >/dev/null 2>&1 &
sleep 1
psql -X -c "select sum(a) from p" 2>&1
wait
