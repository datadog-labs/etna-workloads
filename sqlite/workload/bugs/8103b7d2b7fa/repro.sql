CREATE TABLE t1(a int, b int, check(b>a));
CREATE TABLE t2(x int, y int);
INSERT INTO t2 VALUES(9,1);
INSERT INTO t1 SELECT * FROM t2;
SELECT * FROM t1;
