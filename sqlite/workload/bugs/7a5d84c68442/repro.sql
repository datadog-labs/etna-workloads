.dbconfig defensive off
CREATE VIRTUAL TABLE t1 USING fts5(a, b, c, content='', contentless_delete=1);
INSERT INTO t1(rowid, a, b, c) VALUES(1, 'hello world', 'foo bar', 'baz qux');
INSERT INTO t1(rowid, a, b, c) VALUES(2, 'hello world', 'foo bar', 'baz qux');
UPDATE t1_docsize SET sz = X'02' WHERE id = 1;
DELETE FROM t1 WHERE rowid=1;
SELECT rowid FROM t1('baz');
