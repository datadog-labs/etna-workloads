CREATE VIRTUAL TABLE t1 USING fts5(colA, colB);
INSERT INTO t1 VALUES('A B C', 'D E F');
SELECT snippet(t1, 1,'[',']','...',1) FROM t1 WHERE t1 MATCH 'B';
SELECT snippet(t1, 1,'[',']','...',1) FROM t1 WHERE t1 MATCH 'A';
