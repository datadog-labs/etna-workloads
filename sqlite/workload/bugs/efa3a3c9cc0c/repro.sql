CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1,'a'),(2,'b'),(3,'c'),(4,'d');
SELECT a, sum(a) OVER (ORDER BY a) FROM t1 LIMIT 2;
