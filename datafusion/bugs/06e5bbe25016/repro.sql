SET datafusion.execution.target_partitions = 4;
SET datafusion.execution.batch_size = 3;
CREATE TABLE t1 (k INT, v INT);
CREATE TABLE t2 (k INT, v INT);
INSERT INTO t1 SELECT value AS k, value AS v FROM range(1, 10001) AS t(value);
INSERT INTO t2 VALUES (1, 1);
SELECT * FROM t1 LEFT ANTI JOIN t2 ON t1.k = t2.k ORDER BY t1.k LIMIT 2;
EXPLAIN SELECT * FROM t1 LEFT ANTI JOIN t2 ON t1.k = t2.k ORDER BY t1.k LIMIT 2;
