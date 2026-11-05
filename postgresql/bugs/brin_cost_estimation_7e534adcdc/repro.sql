CREATE TABLE brin_test (a INT, b INT);
INSERT INTO brin_test SELECT x/100,x%100 FROM generate_series(1,10000) x(x);
CREATE INDEX brin_test_a_idx ON brin_test USING brin (a) WITH (pages_per_range = 2);
CREATE INDEX brin_test_b_idx ON brin_test USING brin (b) WITH (pages_per_range = 2);
VACUUM ANALYZE brin_test;
EXPLAIN (COSTS OFF) SELECT * FROM brin_test WHERE a = 1;
EXPLAIN (COSTS OFF) SELECT * FROM brin_test WHERE b = 1;
