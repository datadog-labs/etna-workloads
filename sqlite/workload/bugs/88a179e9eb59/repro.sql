CREATE VIRTUAL TABLE t6 USING fts3(a, b, c, d);
INSERT INTO t6 VALUES('one two three A','one two three B','one two three C','one two three D');
SELECT snippet(t6, '{', '}', '...', 4, 5) FROM t6 WHERE t6 MATCH 'two';
SELECT snippet(t6, '{', '}', '...', 4294967299, 5) FROM t6 WHERE t6 MATCH 'two';
