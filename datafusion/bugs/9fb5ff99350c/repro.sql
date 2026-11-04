SET datafusion.execution.target_partitions = 4;
CREATE TABLE t AS SELECT arrow_cast(column1, 'Binary') AS b FROM (VALUES ('a'),('b'),('c'));
EXPLAIN SELECT count(*) FROM t AS l JOIN t AS r ON l.b = r.b;
SELECT l.b, r.b FROM t AS l JOIN t AS r ON l.b = r.b ORDER BY 1;
