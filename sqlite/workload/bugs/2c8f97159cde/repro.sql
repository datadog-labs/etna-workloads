CREATE TABLE t1(x);
INSERT INTO t1 VALUES(1),(2),(3);
SELECT (1,2,3,max(x)) IN () FROM t1;
SELECT (1,2,max(x),3) IN () FROM t1;
