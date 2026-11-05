psql -X -q -c "DROP TABLE IF EXISTS target; CREATE TABLE target(key int, balance int, val text); INSERT INTO target VALUES (1,160,'setup');"
psql -X -q -c "BEGIN; UPDATE target SET balance=balance+10, val=val||' u1' WHERE key=1; UPDATE target SET balance=balance-100, val=val||' u6' WHERE key=1; SELECT pg_sleep(3); COMMIT;" >/dev/null &
sleep 1
psql -X -q -c "MERGE INTO target t USING (SELECT 1 AS key) s ON s.key=t.key
 WHEN MATCHED AND balance < 100 THEN UPDATE SET balance=balance*2, val=t.val||' when1'
 WHEN MATCHED AND balance < 200 THEN UPDATE SET balance=balance*4, val=t.val||' when2'
 WHEN MATCHED AND balance < 300 THEN UPDATE SET balance=balance*8, val=t.val||' when3';"
wait
psql -X -c "SELECT * FROM target"
