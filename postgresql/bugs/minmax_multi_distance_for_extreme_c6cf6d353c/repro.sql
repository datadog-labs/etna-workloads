CREATE TABLE t(a INTERVAL);
INSERT INTO t SELECT (i || ' years')::interval FROM generate_series(-178000000, -177999980) s(i);
INSERT INTO t SELECT (i || ' years')::interval FROM generate_series(177999980, 178000000) s(i);
CREATE INDEX ON t USING brin (a interval_minmax_multi_ops) WITH (pages_per_range=1);
SET enable_seqscan = off;
EXPLAIN (ANALYZE, TIMING OFF, COSTS OFF, SUMMARY OFF) SELECT * FROM t WHERE a = '30 years'::interval;
