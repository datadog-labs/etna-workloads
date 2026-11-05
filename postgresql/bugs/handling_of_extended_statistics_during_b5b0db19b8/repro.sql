CREATE TABLE t (a int, b text, c int);
INSERT INTO t SELECT i/50, (i/50)::text, i/50 FROM generate_series(0,2999) i;
CREATE STATISTICS s (dependencies) ON a, b FROM t;
ANALYZE t;
ALTER TABLE t ALTER COLUMN c TYPE numeric;
EXPLAIN SELECT * FROM t WHERE a = 1 AND b = '1';
ALTER TABLE t ALTER COLUMN a TYPE bigint;
EXPLAIN SELECT * FROM t WHERE a = 1 AND b = '1';
