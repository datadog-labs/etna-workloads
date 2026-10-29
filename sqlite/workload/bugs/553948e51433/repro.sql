CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1, 2), (3, 4);
SELECT min( sum(a) ) OVER () FROM t1;
