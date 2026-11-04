SET datafusion.execution.target_partitions = 4;
COPY (
  SELECT * FROM VALUES
    ([1,2,3], 100),
    ([3],     200),
    ([],      300),
    ([3,1],   400)
  ORDER BY column2
 ) TO 'ordered_array.parquet';
CREATE EXTERNAL TABLE t
STORED AS PARQUET
LOCATION 'ordered_array.parquet'
WITH ORDER (column2);
SELECT UNNEST(column1), column2 FROM t ORDER BY column2;
EXPLAIN SELECT UNNEST(column1), column2 FROM t ORDER BY column2;
