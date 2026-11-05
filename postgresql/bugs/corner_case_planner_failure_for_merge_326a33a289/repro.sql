CREATE TABLE pa_target (tid integer) PARTITION BY LIST (tid);
CREATE TABLE pa_targetp PARTITION OF pa_target DEFAULT;
CREATE TABLE pa_source (sid integer);
INSERT INTO pa_source VALUES (1);
DROP TABLE pa_targetp;
MERGE INTO pa_target t USING pa_source s ON t.tid = s.sid
  WHEN NOT MATCHED THEN INSERT VALUES (s.sid);
