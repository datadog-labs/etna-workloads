CREATE VIRTUAL TABLE t4 USING fts4;
INSERT INTO t4 VALUES('x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x E x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x');
SELECT length(snippet(t4, '', '', '', 0, 150)) FROM t4 WHERE t4 MATCH 'E';
