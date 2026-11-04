SET datafusion.execution.target_partitions = 4;
EXPLAIN SELECT
    CASE
        WHEN name = 'name1' THEN 0.0
        WHEN name = 'name2' THEN 0.5
    END AS a
FROM (
    SELECT 'name1' AS name
    UNION ALL
    SELECT 'name2'
)
ORDER BY a DESC;

SELECT
    CASE
        WHEN name = 'name1' THEN 0.0
        WHEN name = 'name2' THEN 0.5
    END AS a
FROM (
    SELECT 'name1' AS name
    UNION ALL
    SELECT 'name2'
)
ORDER BY a DESC;
