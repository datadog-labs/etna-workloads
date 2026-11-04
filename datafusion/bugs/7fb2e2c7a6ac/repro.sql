SET datafusion.execution.target_partitions = 4;
COPY (SELECT * FROM (VALUES ('a', '1'), ('a0', '1')) AS t(a, b) ORDER BY a) TO 'concat_ordered.parquet';
CREATE EXTERNAL TABLE concat_ordered (a VARCHAR, b VARCHAR) STORED AS PARQUET WITH ORDER (a) WITH ORDER (b) LOCATION 'concat_ordered.parquet';
EXPLAIN SELECT concat(a, b) AS c FROM concat_ordered ORDER BY c;
SELECT concat(a, b) AS c FROM concat_ordered ORDER BY c;
