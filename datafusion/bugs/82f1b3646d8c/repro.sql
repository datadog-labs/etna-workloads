SET datafusion.execution.target_partitions = 4;
SET datafusion.optimizer.prefer_hash_join = false;
CREATE TABLE nia_left(x INT) AS VALUES (1), (2), (3), (4);
CREATE TABLE nia_right_with_null(y INT) AS VALUES (2), (NULL);
SELECT x FROM nia_left WHERE x NOT IN (SELECT y FROM nia_right_with_null) ORDER BY x;
EXPLAIN SELECT x FROM nia_left WHERE x NOT IN (SELECT y FROM nia_right_with_null);
