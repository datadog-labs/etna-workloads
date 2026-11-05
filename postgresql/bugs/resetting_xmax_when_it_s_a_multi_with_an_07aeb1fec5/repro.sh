psql -X -q -c "drop table if exists foo; create table foo(k int primary key, v int); insert into foo values (1,1);"
( echo "begin; select * from foo for key share; savepoint f; delete from foo; rollback to f; select 'locked';"; sleep 4; echo "commit;" ) | psql -X -q -t >/dev/null &
sleep 2
psql -X -a -q -c "select * from foo for update nowait;" 2>&1
wait
