psql -X -q -c "create table target(key int, val text)" -c "insert into target values (1,'setup1')"
psql -X -q <<'S1' &
BEGIN;
MERGE INTO target t USING (SELECT 1 as key, 'merge1' as val) s ON s.key = t.key
WHEN NOT MATCHED THEN INSERT VALUES (s.key, s.val)
WHEN MATCHED THEN UPDATE set key = t.key + 1, val = t.val || ' updated by ' || s.val;
SELECT pg_sleep(3) \g /dev/null
COMMIT;
S1
sleep 1
psql -X -a -q <<'S2' 2>&1 | grep -v Memory
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF, BUFFERS OFF)
MERGE INTO target t USING (SELECT 1 as key, 'merge2a' as val) s ON s.key = t.key
WHEN NOT MATCHED THEN INSERT VALUES (s.key, s.val)
WHEN MATCHED THEN UPDATE set key = t.key + 1, val = t.val || ' updated by ' || s.val
WHEN NOT MATCHED BY SOURCE THEN UPDATE set key = t.key + 1, val = t.val || ' nm by source'
RETURNING merge_action(), old, new, t.*;
S2
wait
sleep 1
psql -X -c "select * from target order by 1"
