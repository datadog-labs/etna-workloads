SET variant_minimum_shredding_size = 0;
SET explain_output = OPTIMIZED_ONLY;
CREATE TABLE tv AS SELECT (range % 10)::INT::VARIANT AS v FROM range(100);
CHECKPOINT;
EXPLAIN SELECT count(*) FROM tv GROUP BY v;
