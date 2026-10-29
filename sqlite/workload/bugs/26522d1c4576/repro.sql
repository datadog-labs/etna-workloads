CREATE TABLE t(a, c);
INSERT INTO t VALUES(1,'one'),(2,'two'),(3,'three'),(4,'four'),(5,'five');
SELECT a, max(c) OVER (ORDER BY a ROWS BETWEEN 2 FOLLOWING AND 1 FOLLOWING) FROM t;
