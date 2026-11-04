CREATE TABLE test0 AS VALUES ('foo',1), ('bar',2), ('foo',3);
COPY (SELECT arrow_cast(column1, 'Dictionary(Int32, Utf8)') AS column1, column2 FROM test0) TO 'part_dict_test' STORED AS PARQUET PARTITIONED BY (column1);
CREATE EXTERNAL TABLE r STORED AS PARQUET LOCATION 'part_dict_test' PARTITIONED BY (column1);
SELECT column1, column2 FROM r ORDER BY column2;
