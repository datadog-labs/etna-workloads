SET datafusion.execution.target_partitions = 4;
SET datafusion.execution.parquet.pushdown_filters = true;
COPY (
  SELECT column1 AS id, named_struct('x', arrow_cast(column2, 'Int32')) AS s
  FROM VALUES (1, 100), (2, 200), (3, 300)
) TO 'struct_schema_cast.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE t (id BIGINT, s STRUCT<x BIGINT>)
STORED AS PARQUET LOCATION 'struct_schema_cast.parquet';
SELECT id, s['x'] FROM t WHERE s['x'] = 200 ORDER BY id;
SELECT id, s['x'] FROM t WHERE s['x'] > 100 AND id > 2 ORDER BY id;
