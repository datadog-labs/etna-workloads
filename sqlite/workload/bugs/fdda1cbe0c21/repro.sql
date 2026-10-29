CREATE VIRTUAL TABLE t1 USING fts5(a);
INSERT INTO t1 VALUES('one two three four five six seven eight nine ten');
SELECT snippet(t1, 0, '[', ']', '...', 3) FROM t1;
