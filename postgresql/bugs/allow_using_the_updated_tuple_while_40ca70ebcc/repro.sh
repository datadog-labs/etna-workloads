psql -X -q -c "create table pt(a int, b int) partition by list(a); create table p1 partition of pt for values in (1); create table p2 partition of pt for values in (2); insert into pt values (1,0);"
( psql -X -q -c "begin; update pt set b=b+10; select pg_sleep(2); commit;" >/dev/null ) &
sleep 1
psql -X -q -c "update pt set a=2, b=b+1 returning *;"
wait
psql -X -q -c "select * from pt"
