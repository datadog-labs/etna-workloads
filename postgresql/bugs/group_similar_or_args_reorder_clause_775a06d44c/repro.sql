CREATE TABLE t (a int, b int);
INSERT INTO t SELECT i, i FROM generate_series(1,100000) i;
CREATE INDEX ta ON t(a);
CREATE INDEX tb ON t(b);
ANALYZE t;
SET enable_seqscan=off;
EXPLAIN (COSTS OFF) SELECT * FROM t WHERE a < 1 OR b < 2;
EXPLAIN (COSTS OFF) SELECT * FROM t WHERE a < 1 OR a < 3 OR b < 2;
