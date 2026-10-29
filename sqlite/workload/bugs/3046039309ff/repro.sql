CREATE VIRTUAL TABLE t1 USING fts5(x);
INSERT INTO t1(rowid, x) VALUES(10, 'one two');
UPDATE t1 SET x = 'one three' WHERE rowid=10;
INSERT INTO t1(t1, rank) VALUES('secure-delete', 1);
DELETE FROM t1 WHERE rowid=10;
INSERT INTO t1(t1) VALUES('integrity-check');
