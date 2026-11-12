LOAD json;
SELECT variant_extract(var, 'c')::JSON::VARCHAR, variant_extract(var, 'a')::JSON::VARCHAR FROM 'data/parquet-testing/variant_shredded_object1.parquet';
SELECT variant_extract(var, 'c')::JSON::VARCHAR FROM 'data/parquet-testing/variant_shredded_object2.parquet';
SELECT variant_extract(var, 'c')::JSON::VARCHAR FROM 'data/parquet-testing/variant_shredded_object3.parquet';
