CREATE TABLE nd (filler1 int, a int, b int);
INSERT INTO nd SELECT i, i/100, i/100 FROM generate_series(1,1000) s(i);
CREATE STATISTICS nds (ndistinct) ON a, b FROM nd;
ANALYZE nd;
EXPLAIN SELECT COUNT(*) FROM nd GROUP BY ctid, a, b;
