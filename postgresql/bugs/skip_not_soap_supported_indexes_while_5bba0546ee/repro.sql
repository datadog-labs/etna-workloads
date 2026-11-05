CREATE TABLE t AS SELECT 'a'||g AS s FROM generate_series(1,1000) g;
CREATE INDEX ON t USING hash (s);
ANALYZE t;
SET enable_seqscan = off;
EXPLAIN (COSTS OFF) SELECT * FROM t WHERE s = 'a1' OR s = 'a2';
