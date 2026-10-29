CREATE VIRTUAL TABLE t5 USING fts5(c1, tokenize='trigram', detail='none');
INSERT INTO t5(rowid, c1) VALUES(1, 'abc_____xyx_yxz');
INSERT INTO t5(rowid, c1) VALUES(2, 'abc_____xyxz');
INSERT INTO t5(rowid, c1) VALUES(3, 'ac_____xyxz');
SELECT rowid FROM t5 WHERE c1 LIKE 'abc%xyxz';
