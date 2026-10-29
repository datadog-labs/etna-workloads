CREATE TABLE t3(x TEXT PRIMARY KEY COLLATE nocase);
INSERT INTO t3(x) VALUES('aaa'),('abc'),('abd'),('abe'),('acz');
INSERT INTO t3(x) SELECT CAST(x AS blob) FROM t3;
SELECT quote(x) FROM t3 WHERE x LIKE 'ab%' ORDER BY x DESC;
