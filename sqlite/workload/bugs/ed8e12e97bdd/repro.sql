PRAGMA page_size=1024;
CREATE TABLE t1(a TEXT, UNIQUE(a,a,a));
INSERT INTO t1 VALUES (hex(zeroblob(241))),(1),(2),(3);
ANALYZE;
SELECT max(a) FROM t1 WHERE a IN t1;
