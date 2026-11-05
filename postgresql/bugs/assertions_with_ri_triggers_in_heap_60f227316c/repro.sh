psql -X -q -c "create table pk(a int primary key); create table fk(a int references pk on delete set null);"
psql -X -q -c "insert into pk values (2)"
( psql -X -q -c "begin isolation level repeatable read; insert into fk values (2); select pg_sleep(3); commit;" ) &
sleep 1
psql -X -q -c "begin isolation level repeatable read; delete from pk where a=2; commit;" 2>&1
wait
sleep 1
psql -X -q -c "select 1 as alive" 2>&1
