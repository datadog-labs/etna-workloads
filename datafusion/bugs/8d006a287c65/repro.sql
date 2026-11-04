SELECT
    a,
    a IS NOT NULL
FROM (
    SELECT 'foo' AS a, 3 AS b
    UNION ALL
    SELECT NULL AS a, 4 AS b
)
ORDER BY a;
