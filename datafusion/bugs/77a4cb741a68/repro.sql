COPY (SELECT 1 AS id WHERE FALSE) TO 'table_no_rows.parquet';
CREATE EXTERNAL TABLE t STORED AS PARQUET LOCATION 'table_no_rows.parquet';
SELECT count(id) FROM t;
