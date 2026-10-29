CREATE TABLE t(name BLOB);
INSERT INTO t VALUES('B'),('a'),('C');
SELECT name FROM (SELECT name FROM t) ORDER BY name COLLATE nocase;
