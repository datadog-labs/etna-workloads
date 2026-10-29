CREATE TABLE t8(b TEXT, c TEXT);
INSERT INTO t8 VALUES('a','one');
INSERT INTO t8 VALUES('b','two');
INSERT INTO t8 VALUES(NULL,'three');
INSERT INTO t8 VALUES(NULL,'four');
CREATE UNIQUE INDEX i1 ON t8(b);
SELECT coalesce(b,'null')||'/'||c FROM t8 x ORDER BY x.b, x.c;
