SELECT count(*) FROM 'data/parquet-testing/variant_shredded_object1.parquet' WHERE var.A = 123456789;
SELECT variant_extract(var, 'A') FROM 'data/parquet-testing/variant_shredded_object1.parquet';
