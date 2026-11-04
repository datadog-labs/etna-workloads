SET datafusion.execution.target_partitions = 4;
CREATE TABLE t(g varchar, v bigint) AS VALUES
(NULL, 0), ('a', NULL), ('b', NULL), ('c', 5), ('c', 3), ('d', 1);
CREATE TABLE s(g varchar, v varchar) AS VALUES
('a', NULL), ('b', 'x'), ('c', NULL), ('d', 'z');
SELECT g, max(v) m FROM t GROUP BY g ORDER BY m DESC NULLS LAST, g LIMIT 10;
SELECT g, max(v) m FROM t GROUP BY g ORDER BY m DESC LIMIT 5;
SELECT g, min(v) m FROM t GROUP BY g ORDER BY m ASC NULLS LAST LIMIT 5;
SELECT g, max(v) m FROM s GROUP BY g ORDER BY m DESC NULLS LAST LIMIT 4;
SELECT g, max(g) m FROM t GROUP BY g ORDER BY m DESC LIMIT 2;
EXPLAIN SELECT g, max(v) m FROM t GROUP BY g ORDER BY m DESC LIMIT 2;
