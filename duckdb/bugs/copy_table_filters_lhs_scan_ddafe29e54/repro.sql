.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
CREATE TABLE lm_test (
    id INTEGER,
    grp INTEGER,
    ts TIMESTAMP,
    payload1 VARCHAR,
    payload2 VARCHAR,
    payload3 VARCHAR,
    payload4 VARCHAR,
    payload5 VARCHAR
);
INSERT INTO lm_test
SELECT
    i AS id,
    (i % 100) + 1 AS grp,
    TIMESTAMP '2024-01-01' + INTERVAL (i * 60) SECOND AS ts,
    md5(i::VARCHAR || 'p1') AS payload1,
    md5(i::VARCHAR || 'p2') AS payload2,
    md5(i::VARCHAR || 'p3') AS payload3,
    md5(i::VARCHAR || 'p4') AS payload4,
    md5(i::VARCHAR || 'p5') AS payload5
FROM generate_series(1, 100000) t(i);
CHECKPOINT;
SELECT count(*) FROM lm_test WHERE grp = 1;
SET late_materialization_max_rows = 100;
SELECT count(*) FROM (
    SELECT id, grp, ts, payload1, payload2, payload3, payload4, payload5
    FROM lm_test
    WHERE grp = 1
      AND ts >= TIMESTAMP '2024-01-01'
      AND ts < TIMESTAMP '2024-07-01'
    ORDER BY ts
    LIMIT 20
) sub;
EXPLAIN
SELECT id, grp, ts, payload1, payload2, payload3, payload4, payload5
FROM lm_test
WHERE grp = 1
  AND ts >= TIMESTAMP '2024-01-01'
  AND ts < TIMESTAMP '2024-07-01'
ORDER BY ts
LIMIT 20;
SELECT id, grp, ts
FROM lm_test
WHERE grp = 1
  AND ts >= TIMESTAMP '2024-01-01'
  AND ts < TIMESTAMP '2024-07-01'
ORDER BY ts
LIMIT 3;
SET late_materialization_max_rows = 0;
SELECT id, grp, ts
FROM lm_test
WHERE grp = 1
  AND ts >= TIMESTAMP '2024-01-01'
  AND ts < TIMESTAMP '2024-07-01'
ORDER BY ts
LIMIT 3;
SET late_materialization_max_rows = 100;
SELECT payload1 = md5(id::VARCHAR || 'p1')
FROM lm_test
WHERE grp = 1
  AND ts >= TIMESTAMP '2024-01-01'
  AND ts < TIMESTAMP '2024-07-01'
ORDER BY ts
LIMIT 1;
SET late_materialization_max_rows = 100;
EXPLAIN SELECT id, grp, ts, payload1, payload2, payload3, payload4, payload5
FROM lm_test ORDER BY ts LIMIT 3;
SELECT id, grp, ts
FROM lm_test ORDER BY ts LIMIT 3;
EXPLAIN SELECT id, grp, ts, payload1
FROM lm_test WHERE grp = 1 ORDER BY ts LIMIT 3;
