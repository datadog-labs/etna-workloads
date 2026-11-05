CREATE TABLE t AS SELECT g::float8 a, g::float8 b FROM generate_series(1,20000) g;
ALTER TABLE t SET (parallel_workers=4);
SET parallel_setup_cost=0;
SET parallel_tuple_cost=0;
SET min_parallel_table_scan_size=0;
SET max_parallel_workers_per_gather=4;
EXPLAIN (COSTS OFF) SELECT regr_count(a,b) FROM t;
SELECT regr_count(a,b) FROM t;
