CREATE TABLE distinct_pct(id INT, x DOUBLE) AS VALUES (1, 5), (2, 5), (3, 9);
SELECT id, percentile_cont(DISTINCT x, 0.5) OVER (ORDER BY id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS p FROM distinct_pct ORDER BY id;
