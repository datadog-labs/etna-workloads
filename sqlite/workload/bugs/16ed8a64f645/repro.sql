CREATE VIRTUAL TABLE t USING fts5(a,b,c);
CREATE TABLE d(a,b,c);
INSERT INTO d VALUES(1,2,3),('a','b','c');
INSERT INTO t(a,b,c) SELECT * FROM d;
SELECT rowid,* FROM t;
