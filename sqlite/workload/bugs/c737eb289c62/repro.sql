CREATE VIRTUAL TABLE t3 USING fts5(c0);
INSERT INTO t3(rowid, c0) VALUES(1, 'x');
INSERT INTO t3(rowid, c0) VALUES(2, 'x b z');
SELECT rowid FROM t3 WHERE t3 MATCH 'z NOT (b OR -{c0} : x)';
CREATE VIRTUAL TABLE t4 USING fts5(c0);
INSERT INTO t4(rowid, c0) VALUES(1, 'a');
INSERT INTO t4(rowid, c0) VALUES(2, 'a');
SELECT rowid FROM t4 WHERE t4 MATCH 'a AND (-{c0} : a)';
