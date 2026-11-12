SET variant_minimum_shredding_size = 0;
CREATE TABLE t(v VARIANT);
INSERT INTO t VALUES ({'a': 1}::VARIANT), ({'A': 2}::VARIANT);
FORCE CHECKPOINT;
SELECT stats(v).fully_shredded IS NULL FROM t LIMIT 1;
SELECT variant_keys(v), variant_extract(v,'a')::INT, variant_extract(v,'A')::INT FROM t ORDER BY 1;
