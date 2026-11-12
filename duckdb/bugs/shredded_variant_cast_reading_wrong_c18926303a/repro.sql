SET variant_minimum_shredding_size = 0;
CREATE TABLE t (id INT, v VARIANT);
INSERT INTO t SELECT i, [i, i+1]::VARIANT FROM range(3) r(i);
CHECKPOINT;
SELECT id, v::VARCHAR FROM t ORDER BY id;
