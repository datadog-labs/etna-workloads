CREATE VIRTUAL TABLE t1 USING fts5(a);
SELECT highlight(t1, 4, '<b>', '</b>') FROM t1('*');
SELECT highlight(t1, 4, '<b>', '</b>') FROM t1('*id');
SELECT highlight(t1, 4, '<b>', '</b>') FROM t1('*reads');
