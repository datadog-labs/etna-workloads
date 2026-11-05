CREATE TABLE p (a int, b int) PARTITION BY RANGE (a);
CREATE TABLE p1 PARTITION OF p FOR VALUES FROM (0) TO (1000);
INSERT INTO p SELECT i/100, i/100 FROM generate_series(0,9999) i;
CREATE STATISTICS s (ndistinct) ON a, b FROM p;
ANALYZE p;
SELECT count(*) FROM pg_statistic_ext_data WHERE stxoid='s'::regclass AND stxdndistinct IS NOT NULL;
EXPLAIN SELECT a, b FROM p GROUP BY 1, 2;
