SELECT
    x,
    median(x) OVER (
        ORDER BY x
        RANGE BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS median_val
FROM (VALUES (1.0), (1.0), (2.0), (5.0)) AS t(x)
ORDER BY x;
