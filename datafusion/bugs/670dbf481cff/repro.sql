COPY (select {f1: 1, f2: 2} as s) TO 'test.parquet' STORED AS PARQUET;

CREATE EXTERNAL TABLE t STORED AS PARQUET LOCATION 'test.parquet';

EXPLAIN SELECT get_field(s, 'f1') AS __datafusion_extracted_2
FROM t
WHERE COALESCE(get_field(s, 'f1'), get_field(s, 'f2')) = 1;

SELECT get_field(s, 'f1') AS __datafusion_extracted_2
FROM t
WHERE COALESCE(get_field(s, 'f1'), get_field(s, 'f2')) = 1;
