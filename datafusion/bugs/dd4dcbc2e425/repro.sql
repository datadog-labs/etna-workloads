SET datafusion.execution.target_partitions = 4;
SET datafusion.execution.parquet.pushdown_filters = true;
COPY (VALUES (10), (20), (30)) TO 'pq/first.parquet' STORED AS PARQUET;
COPY (VALUES (40), (50), (60)) TO 'pq/second.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE pq_table(column1 int) STORED AS PARQUET LOCATION 'pq/';
SELECT column1 FROM pq_table WHERE input_file_name() LIKE '%first.parquet' ORDER BY column1;
SELECT input_file_name() LIKE '%parquet' AS f, file_row_index(), column1 FROM pq_table WHERE file_row_index() = 2 AND input_file_name() LIKE '%parquet' ORDER BY column1;
