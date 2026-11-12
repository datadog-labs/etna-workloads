SELECT variant_to_parquet_variant(repeat('a',64)::VARIANT) AS v;
SELECT variant_to_parquet_variant(repeat('a',63)::VARIANT) AS v;
