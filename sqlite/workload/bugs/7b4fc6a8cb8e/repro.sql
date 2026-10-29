CREATE TABLE t8(a INTEGER PRIMARY KEY, b TEXT UNIQUE, c CHAR(100));
INSERT INTO t8(a,b) VALUES(1,'one');
INSERT INTO t8(a,b) VALUES(4,'four');
SELECT x.a || '/' || y.a FROM t8 x, t8 y ORDER BY x.a, y.b DESC;
SELECT x.a || '/' || y.a FROM t8 x, t8 y ORDER BY x.b, x.a, y.a||y.b;
