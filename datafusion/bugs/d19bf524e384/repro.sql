SET datafusion.execution.target_partitions = 4;
COPY (SELECT '00000000000000000000000000000001' AS trace_id, '2023-10-01 00:00:00'::timestamptz AS start_timestamp, 'prod' AS deployment_environment) TO 'data/1.parquet';
COPY (SELECT '00000000000000000000000000000002' AS trace_id, '2024-10-01 00:00:00'::timestamptz AS start_timestamp, 'staging' AS deployment_environment) TO 'data/2.parquet';
CREATE EXTERNAL TABLE t1 STORED AS PARQUET LOCATION 'data/';
SET datafusion.execution.parquet.pushdown_filters = true;
SELECT start_timestamp FROM t1
WHERE trace_id = '00000000000000000000000000000002' AND deployment_environment = 'staging'
ORDER BY start_timestamp, trace_id LIMIT 1;
EXPLAIN SELECT start_timestamp FROM t1
WHERE trace_id = '00000000000000000000000000000002' AND deployment_environment = 'staging'
ORDER BY start_timestamp, trace_id LIMIT 1;
