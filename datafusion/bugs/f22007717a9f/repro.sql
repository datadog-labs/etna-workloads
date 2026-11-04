SET datafusion.execution.target_partitions = 4;
CREATE TABLE t22489 (g INT, x INT, y INT) AS VALUES (1, 10, 4), (2, 20, 3), (3, 30, 2), (4, 40, 1);
SELECT * FROM (
  SELECT g, SUM(x) AS sx, SUM(y) AS sy FROM t22489 GROUP BY g
  ORDER BY sx DESC LIMIT 4
) q
ORDER BY sy DESC
OFFSET 1;
