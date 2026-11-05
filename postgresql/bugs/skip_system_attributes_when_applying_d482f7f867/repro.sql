CREATE TABLE nd (a int, b int);
INSERT INTO nd SELECT i/100, i/100 FROM generate_series(1,10000) i;
CREATE STATISTICS s (ndistinct) ON a, b FROM nd;
ANALYZE nd;
EXPLAIN (COSTS OFF) SELECT count(*) FROM nd GROUP BY ctid, a, b;
