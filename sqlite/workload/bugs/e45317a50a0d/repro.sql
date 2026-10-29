CREATE VIRTUAL TABLE t1 USING fts5(ab);
INSERT INTO t1(t1, rank) VALUES('pgsz', 64);
INSERT INTO t1(rowid, ab) VALUES(1, 'abcdefg');
INSERT INTO t1(rowid, ab) VALUES(2, 'abcdefg');
INSERT INTO t1(rowid, ab) VALUES(3, 'abcdefg');
INSERT INTO t1(t1, rank) VALUES('secure-delete', 1);
.dbconfig defensive off
PRAGMA writable_schema=1;
DROP TABLE t1_config;
BEGIN;
UPDATE t1 SET ab='abcdefg' WHERE rowid=2;
COMMIT;
