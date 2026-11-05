CREATE TABLE t (a int, b int, c int);
INSERT INTO t SELECT i%20, i%20, i FROM generate_series(1,1000) i;
CREATE STATISTICS s2 (mcv) ON mod(a,20), mod(b,20) FROM t;
ANALYZE t;
EXPLAIN SELECT * FROM t WHERE mod(a,20) = 1 AND mod(b,20) = 1;
CREATE STATISTICS s3 (mcv) ON a, b FROM t;
ANALYZE t;
EXPLAIN SELECT * FROM t WHERE mod(a,20) = 1 AND mod(b,20) = 1;
EXPLAIN SELECT * FROM t WHERE (case a when 1 then true else false end) AND b=2;
