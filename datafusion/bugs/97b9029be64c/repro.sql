COPY (SELECT 1::int AS a, 2::int AS b)
TO 'mixed_stats.parquet'
STORED AS PARQUET OPTIONS ('STATISTICS_ENABLED::b' 'none');

CREATE EXTERNAL TABLE t STORED AS PARQUET LOCATION 'mixed_stats.parquet';

SELECT b FROM t WHERE b = 2;
SELECT b FROM t WHERE b IS NULL;
SELECT count(b), count(*) FROM t;
