CREATE TABLE t(x);
INSERT INTO t VALUES(1);
SELECT x, value FROM t LEFT JOIN generate_series(1,5) ON 1 WHERE value IS ?1;
