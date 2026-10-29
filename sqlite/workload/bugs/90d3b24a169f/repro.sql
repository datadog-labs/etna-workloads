CREATE VIRTUAL TABLE t4 USING fts5(a, b, c, detail=none);
SELECT * FROM t4('a:a &');
