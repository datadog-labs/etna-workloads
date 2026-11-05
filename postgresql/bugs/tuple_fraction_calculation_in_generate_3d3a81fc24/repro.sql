CREATE TABLE fract_t (id BIGINT, PRIMARY KEY (id)) PARTITION BY RANGE (id);
CREATE TABLE fract_t0 PARTITION OF fract_t FOR VALUES FROM ('0') TO ('1000');
CREATE TABLE fract_t1 PARTITION OF fract_t FOR VALUES FROM ('1000') TO ('2000');
INSERT INTO fract_t (id) (SELECT generate_series(0, 1999));
ANALYZE fract_t;
SET max_parallel_workers_per_gather = 0;
SET enable_partitionwise_join = on;
EXPLAIN (COSTS OFF)
SELECT x.id, y.id FROM fract_t x LEFT JOIN fract_t y USING (id)
ORDER BY x.id DESC LIMIT 2;
