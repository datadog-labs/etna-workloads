CREATE VIRTUAL TABLE ft USING fts5(x, content='', contentless_delete=1);
INSERT INTO ft VALUES('hello world');
INSERT INTO ft VALUES('one two three');
BEGIN;
INSERT INTO ft(rowid, x) VALUES(3, 'four four four');
DELETE FROM ft WHERE rowid=3;
COMMIT;
SELECT rowid FROM ft('four');
