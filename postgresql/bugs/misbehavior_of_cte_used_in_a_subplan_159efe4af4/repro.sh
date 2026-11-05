psql -X -q -c "create table table_a(id int, value text); insert into table_a values (1,'x');"
(echo "begin; update table_a set value='v2' where id=1; select pg_sleep(2);commit;") | psql -X -q &
sleep 1
psql -X -q -c "WITH updated AS (UPDATE table_a SET value='v3' WHERE id=1 RETURNING id) SELECT (SELECT id FROM updated) AS subid, * FROM updated;"
wait
