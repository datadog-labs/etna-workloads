WITH RECURSIVE t AS (
    SELECT 1 i
    UNION ALL
    SELECT g.i
    FROM generate_series(1, 1) g(i), t
)
SELECT *
FROM t
LIMIT 10;
