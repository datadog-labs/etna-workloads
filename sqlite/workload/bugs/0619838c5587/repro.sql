CREATE VIRTUAL TABLE t9 USING fts5(x, detail=full);
INSERT INTO t9(rowid, x) VALUES(2, 'bbb');
BEGIN;
  INSERT INTO t9(rowid, x) VALUES(1, 'aaa');
  DELETE FROM t9 WHERE rowid = 2;
  INSERT INTO t9(rowid, x) VALUES(3, 'bbb');
COMMIT;
SELECT rowid FROM t9('a*');
