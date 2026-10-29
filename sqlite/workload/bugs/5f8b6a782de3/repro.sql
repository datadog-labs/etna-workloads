CREATE VIRTUAL TABLE t USING fts3(a, b, c, d);
INSERT INTO t VALUES('one two three','x','y','z');
SELECT '[' || snippet(t, '[', ']', '...', 4294967299, 5) || ']' FROM t WHERE t MATCH 'two';
SELECT '[' || snippet(t, '[', ']', '...', -4294967293, 5) || ']' FROM t WHERE t MATCH 'two';
