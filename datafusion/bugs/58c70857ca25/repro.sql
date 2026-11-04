SET datafusion.execution.target_partitions = 4;
CREATE TABLE t1(v1 BOOL);
INSERT INTO t1 VALUES (TRUE);
SELECT approx_percentile_cont_with_weight('NaN'::DOUBLE, 0, 0) FROM t1 WHERE t1.v1;
