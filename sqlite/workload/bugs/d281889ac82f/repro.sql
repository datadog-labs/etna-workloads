CREATE TABLE t1(x);
INSERT INTO t1 VALUES(1),('a');
SELECT percentile(x, 50) FROM t1;
SELECT percentile_cont(x, 0.5) FROM t1;
SELECT median(x) FROM t1;
UPDATE t1 SET x=1.0e300*1.0e300 WHERE x=1;
SELECT percentile_disc(x, 0.5) FROM t1;
