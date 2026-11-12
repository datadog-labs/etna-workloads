SET errors_as_json = false;
SET variant_minimum_shredding_size = 0;
CREATE TABLE s AS SELECT i AS id, (i % 2 = 0)::VARIANT AS v FROM range(5) t(i);
CHECKPOINT;
SELECT variant_extract(v, 'a') FROM s WHERE id = 1;
