CREATE VIRTUAL TABLE t1 USING fts5(a, b, detail=none);
INSERT INTO t1 VALUES('a1 b1 c1', 'x y z');
INSERT INTO t1 VALUES('a2 b2 c2', '1 2 3');
INSERT INTO t1 VALUES('a1 b1 c1', 'x 2 z');
INSERT INTO t1(t1) VALUES('integrity-check');
