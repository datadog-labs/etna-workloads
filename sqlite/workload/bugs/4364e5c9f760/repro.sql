CREATE VIRTUAL TABLE t1 USING fts5(x, detail=none);
BEGIN;
INSERT INTO t1(rowid, x) VALUES(1, 'sqlite');
INSERT INTO t1(rowid, x) VALUES(2, 'sqlite');
COMMIT;
DELETE FROM t1;
SELECT rowid FROM t1('sqlite') ORDER BY rowid DESC;
INSERT INTO t1(t1) VALUES('integrity-check');
