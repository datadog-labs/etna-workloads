CREATE TABLE t0(aa COLLATE NOCASE, bb);
INSERT INTO t0 VALUES('a', 'A');
SELECT (+bb,1) >= (aa, 1), (aa,1)<=(+bb,1) FROM t0;
SELECT 2 FROM t0 WHERE (+bb,1) >= (aa,1);
SELECT 3 FROM t0 WHERE (aa,1) <= (+bb,1);
