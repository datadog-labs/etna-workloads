psql -X -q -c "create table p(a int)" -c "insert into p values (1)"
(echo "create temp table c() inherits (p); insert into c values (2);"; sleep 4) | psql -X -q &
sleep 1
psql -X -a -q -c "truncate p" -c "select * from p"
wait
psql -X -q -c "drop table p cascade"
