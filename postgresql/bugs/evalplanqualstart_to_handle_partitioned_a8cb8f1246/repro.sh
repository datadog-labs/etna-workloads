psql -X -q -c "create table parttbl (a int) partition by list (a); create table parttbl1 partition of parttbl for values in (1); insert into parttbl values (1);"
( echo "begin; update parttbl set a = a;"; sleep 3; echo "commit;" ) | psql -X -q &
sleep 1
psql -X -q -c "with u as (update parttbl set a = a returning parttbl.*) update parttbl set a = u.a from u;" 2>&1
wait
psql -X -q -c "select * from parttbl"
