SET datafusion.execution.target_partitions = 2;
CREATE TABLE test(a INT, b INT, c INT) AS VALUES (1,2,3), (4,5,6), (null,7,8), (8,null,9), (9,10,null);
EXPLAIN SELECT * FROM test WHERE a IN (SELECT a FROM test WHERE b > 3) ORDER BY c DESC NULLS FIRST;
SELECT * FROM test WHERE a IN (SELECT a FROM test WHERE b > 3) ORDER BY c DESC NULLS FIRST;
