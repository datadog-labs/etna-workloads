SET datafusion.execution.target_partitions = 2;
COPY (VALUES (1, 'a'), (2, 'b')) TO 't/0.parquet' STORED AS PARQUET;
COPY (VALUES (3, 'c'), (4, 'd')) TO 't/1.parquet' STORED AS PARQUET;
COPY (VALUES (5, 'e'), (6, 'f')) TO 't/2.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE tt (column1 INT, column2 TEXT) STORED AS PARQUET
WITH ORDER (column1 ASC NULLS LAST) LOCATION 't/';
EXPLAIN SELECT column1 FROM tt ORDER BY column1;
SELECT column1 FROM tt ORDER BY column1;
