CREATE VIRTUAL TABLE t4 USING fts4;
INSERT INTO t4 VALUES('a b c d');
SELECT snippet(t4, '[', ']', '...', 0, 0) FROM t4 WHERE t4 MATCH 'b';
