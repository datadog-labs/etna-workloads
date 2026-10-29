CREATE TABLE t1(a);
INSERT INTO t1 VALUES(1),(2),(3);
SELECT percent_rank() OVER () FROM t1;
SELECT cume_dist() OVER () FROM t1;
