SELECT variant_extract((SELECT list(i) FROM range(500) t(i))::VARIANT, 300::UINTEGER)::BIGINT;
