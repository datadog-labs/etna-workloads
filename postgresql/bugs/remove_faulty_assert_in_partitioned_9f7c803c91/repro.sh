psql -X -q -c "CREATE TABLE upsert (i int PRIMARY KEY, j int, k int) PARTITION BY RANGE (i);
CREATE TABLE upsert_1 PARTITION OF upsert FOR VALUES FROM (1) TO (100);
CREATE TABLE upsert_2 PARTITION OF upsert FOR VALUES FROM (100) TO (200);
INSERT INTO upsert VALUES (1, 10, 100);"
psql -X -q -c "BEGIN; SELECT * FROM upsert WHERE i = 1 FOR UPDATE; SELECT pg_sleep(3); UPDATE upsert SET i = i + 150 WHERE i = 1; COMMIT;" >/dev/null 2>&1 &
sleep 1
psql -X -q -c "INSERT INTO upsert VALUES (1, 11, 111) ON CONFLICT (i) DO UPDATE SET k = EXCLUDED.k;" >/dev/null 2>&1
wait
sleep 2
psql -X -q -c "SELECT * FROM upsert ORDER BY i;" 2>&1
