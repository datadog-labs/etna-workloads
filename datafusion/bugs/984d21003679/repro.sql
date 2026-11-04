set datafusion.optimizer.prefer_hash_join = false;
CREATE TABLE t1(a int, b int) AS VALUES (1, 100), (2, 200), (3, 300);
CREATE TABLE t2(a int, b int, c int) AS VALUES (4, 101, 1001), (3, 201, 2001), (2, 250, 3001);
SELECT * FROM t1 LEFT JOIN t2 on t1.a = t2.a AND t1.b < t2.b ORDER BY t1.a;
