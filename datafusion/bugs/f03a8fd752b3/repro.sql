SET datafusion.execution.target_partitions = 4;
COPY (SELECT column1 as a, column2 as b FROM (VALUES ('foo', 1), ('bar', 2), ('foo', 3), ('baz', 50))) TO 'pt/1.parquet' STORED AS PARQUET;
COPY (SELECT column1 as b FROM (VALUES (10), (20), (30))) TO 'pt/2.parquet' STORED AS PARQUET;
SET datafusion.execution.parquet.pushdown_filters = false;
CREATE EXTERNAL TABLE t(a varchar, b int, c float) STORED AS PARQUET LOCATION 'pt/';
SET datafusion.execution.parquet.pushdown_filters = true;
SELECT a FROM t WHERE b > 2 ORDER BY a;
