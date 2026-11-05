CREATE TABLE pa_target (tid integer, balance float, val text) PARTITION BY LIST (tid);
CREATE TABLE part1 PARTITION OF pa_target FOR VALUES IN (1,4);
MERGE INTO pa_target t USING (VALUES (10, 100)) AS s(sid, delta) ON t.tid = s.sid
  WHEN NOT MATCHED THEN INSERT VALUES (1, 10, 'inserted by merge')
  WHEN MATCHED THEN DO NOTHING;
SELECT * FROM pa_target;
