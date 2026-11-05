psql -X -q -c "drop table if exists mc; create table mc(a int); insert into mc values (1)"
( echo "BEGIN; SELECT * FROM mc FOR KEY SHARE; SAVEPOINT foo; SELECT * FROM mc FOR SHARE;"; sleep 3; echo "COMMIT;" ) | psql -X -q -o /dev/null &
sleep 1
psql -X -a -q -c "SELECT * FROM mc FOR NO KEY UPDATE NOWAIT" 2>&1
wait
