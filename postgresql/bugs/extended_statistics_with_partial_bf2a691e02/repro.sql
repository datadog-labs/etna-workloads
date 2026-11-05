CREATE TABLE t (a int, b int);
INSERT INTO t SELECT i, i FROM generate_series(1,100) i;
CREATE STATISTICS s (dependencies) ON a, b FROM t;
ANALYZE t (a);
SELECT count(*) FROM pg_statistic WHERE starelid='t'::regclass;
