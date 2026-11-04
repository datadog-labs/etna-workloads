SET datafusion.execution.target_partitions = 4;
COPY (SELECT 1 AS id UNION ALL SELECT 2 UNION ALL SELECT 3) TO 'volatile.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE volatile_scan STORED AS PARQUET LOCATION 'volatile.parquet';
SELECT s.x = s.y AS eq
FROM (SELECT r AS x, r AS y FROM (SELECT random() AS r FROM volatile_scan) AS t) AS s;
