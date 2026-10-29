CREATE VIRTUAL TABLE t2 USING fts4(x, languageid=l);
INSERT INTO t2(docid, x, l) VALUES(1, 'one', 1);
INSERT INTO t2(docid, x, l) VALUES(2, 'one', 1);
INSERT INTO t2(docid, x, l) VALUES(3, 'one', 2);
INSERT INTO t2(docid, x, l) VALUES(4, 'one', 2);
INSERT INTO t2(t2) VALUES('optimize');
SELECT count(*) FROM t2_segdir;
SELECT docid FROM t2 WHERE t2 MATCH 'one' AND l=1;
SELECT docid FROM t2 WHERE t2 MATCH 'one' AND l=2;
