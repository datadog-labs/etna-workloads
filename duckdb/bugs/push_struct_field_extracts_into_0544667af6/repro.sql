SELECT count(*) FROM read_parquet(['data/parquet-testing/bug1618_struct_strings.parquet','data/parquet-testing/bug1618_struct_strings.parquet'], union_by_name = true)
WHERE "inner".f64_field = 1.23;
