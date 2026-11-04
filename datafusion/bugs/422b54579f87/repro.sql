SET datafusion.execution.target_partitions = 1;
SET datafusion.explain.analyze_categories = 'rows';
EXPLAIN ANALYZE
WITH t1 (k) AS (
    VALUES (1), (2)
), t2 (k) AS (
    VALUES (1)
)
SELECT *
FROM t1
LEFT ANTI JOIN (
    SELECT *
    FROM t2
    WHERE k <> 1
) t2 ON t1.k = t2.k;
