SET datafusion.execution.target_partitions = 4;
SET datafusion.explain.format = indent;
CREATE TABLE t AS SELECT v % 5 AS c1 FROM generate_series(1, 100) AS g(v);
EXPLAIN SELECT count(1) AS cnt FROM (SELECT DISTINCT c1 FROM t) AS a
  UNION ALL SELECT 1 AS cnt
  UNION ALL SELECT lead(c1, 1) OVER () AS cnt FROM (SELECT 1 AS c1) AS b
  LIMIT 3;
