CREATE TABLE t1 (a int UNIQUE);
CREATE TABLE t2 (b int UNIQUE);
INSERT INTO t1 VALUES (1);
INSERT INTO t2 VALUES (1), (2);
SELECT t1.a, t2.b FROM t1, t2 WHERE (t1.a, t2.b) = (1, 1);
SELECT t1.a, t2.b FROM t1, t2 WHERE (t1.a, t2.b) IN ((1, 1));
SELECT t1.a, t2.b FROM t1, t2 WHERE (t1.a, t2.b) = (1, 2);
SELECT t1.a, t2.b FROM t1, t2 WHERE (t1.a, t2.b) IN ((1, 2));
