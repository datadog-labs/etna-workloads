SET datafusion.execution.target_partitions = 1;
CREATE TABLE agg_expr_data(x INT, y INT, v INT) AS VALUES
(1, 1, 10),(1, 2, 20),(1, 3, 30),(2, 1, 40),(2, 2, 50),(2, 3, 60);
COPY (SELECT * FROM agg_expr_data ORDER BY x, y) TO 'agg_expr_sorted.parquet';
CREATE EXTERNAL TABLE agg_expr_parquet(x INT, y INT, v INT)
STORED AS PARQUET LOCATION 'agg_expr_sorted.parquet'
WITH ORDER (x ASC, y ASC);
EXPLAIN SELECT x, CAST(y AS BIGINT) % 2, SUM(v) FROM agg_expr_parquet
GROUP BY x, CAST(y AS BIGINT) % 2 ORDER BY x, CAST(y AS BIGINT) % 2;
SELECT x, CAST(y AS BIGINT) % 2, SUM(v) FROM agg_expr_parquet
GROUP BY x, CAST(y AS BIGINT) % 2 ORDER BY x, CAST(y AS BIGINT) % 2;
