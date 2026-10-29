CREATE TABLE c(l, x, y);
INSERT INTO c(rowid, l, x, y) VALUES(1, 0, 'one two', 'x y');
CREATE VIRTUAL TABLE t USING fts4(content=c, languageid=l);
INSERT INTO t(t) VALUES('rebuild');
SELECT docid FROM t WHERE t MATCH 'one' AND l=0;
