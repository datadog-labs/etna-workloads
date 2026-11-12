SELECT d, "inner".str_field
FROM read_parquet(['data/parquet-testing/struct.parquet','data/parquet-testing/date.parquet'], union_by_name=true)
ORDER BY ALL;
