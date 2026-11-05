CREATE TABLE t (a int, b int);
INSERT INTO t SELECT x/10, x/3 FROM generate_series(1,100) x;
CREATE STATISTICS s ON (case a when 1 then true else false end), b FROM t;
ANALYZE t;
EXPLAIN (COSTS OFF) SELECT * FROM t WHERE (case a when 1 then true else false end);
SELECT count(*) FROM t WHERE (case a when 1 then true else false end) AND b = 3;
