CREATE TABLE t(x);
INSERT INTO t VALUES('a'),('b'),('c');
SELECT group_concat(CASE x WHEN 'a' THEN '' ELSE x END) FROM t;
SELECT group_concat(CASE WHEN x!='c' THEN '' ELSE x END) FROM t;
