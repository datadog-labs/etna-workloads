SET enable_mergejoin TO off;
SET enable_hashjoin TO off;
CREATE TABLE expr_key (x numeric, t text);
INSERT INTO expr_key (x, t)
SELECT d1::numeric, d1::text FROM (
    SELECT round((d / pi())::numeric, 7) AS d1 FROM generate_series(1, 20) AS d
) t;
INSERT INTO expr_key SELECT * FROM expr_key;
CREATE INDEX expr_key_idx_x_t ON expr_key (x, t);
VACUUM ANALYZE expr_key;
EXPLAIN (ANALYZE, BUFFERS OFF, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT * FROM expr_key t1 INNER JOIN expr_key t2
ON t1.x = t2.t::numeric AND t1.t::numeric = t2.x;
