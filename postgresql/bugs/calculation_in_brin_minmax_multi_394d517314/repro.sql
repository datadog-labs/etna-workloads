CREATE TABLE brin_date_test(a DATE);
INSERT INTO brin_date_test SELECT '4713-01-01 BC'::date + i FROM generate_series(1, 30) s(i);
INSERT INTO brin_date_test SELECT '5874897-12-01'::date + i FROM generate_series(1, 30) s(i);
CREATE INDEX ON brin_date_test USING brin (a date_minmax_multi_ops) WITH (pages_per_range=1);
SET enable_seqscan = off;
EXPLAIN (ANALYZE, TIMING OFF, COSTS OFF, SUMMARY OFF, BUFFERS OFF)
SELECT * FROM brin_date_test WHERE a = '2023-01-01'::date;
