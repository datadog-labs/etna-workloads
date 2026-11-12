.mode list
.nullvalue NULL
PRAGMA enable_verification;
CREATE TABLE t AS
SELECT i, TIMESTAMP '2024-01-01' + INTERVAL (i * 60) SECOND AS ts
FROM generate_series(0, 9) s(i);
SELECT COUNT(*) FROM t, LATERAL range(ts, ts + INTERVAL '5 minutes', INTERVAL '10 minutes');
SELECT COUNT(*) FROM t, LATERAL range(
    ts + (CASE WHEN i = 5 THEN INTERVAL '7 minutes' ELSE INTERVAL '0 minutes' END),
    ts + INTERVAL '5 minutes',
    INTERVAL '10 minutes');
