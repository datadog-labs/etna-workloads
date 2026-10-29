CREATE TABLE t4(x, y);
INSERT INTO t4 VALUES(1,'g'),(2,'i'),(3,'l'),(4,'g'),(5,'a');
SELECT x, y, max(y) OVER (PARTITION BY (x%2) ORDER BY x) FROM t4 ORDER BY 1;
