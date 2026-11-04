SET datafusion.execution.parquet.coerce_int96 = ms;
CREATE EXTERNAL TABLE int96_from_spark STORED AS PARQUET LOCATION '../testdata/parquet-testing/data/int96_from_spark.parquet';
DESCRIBE int96_from_spark;
