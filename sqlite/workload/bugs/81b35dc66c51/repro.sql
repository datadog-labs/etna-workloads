CREATE VIRTUAL TABLE t5 USING fts4(languageid=lid);
INSERT INTO t5(docid, content, lid) VALUES(0, 'My language is 0', 0);
INSERT INTO t5(docid, content, lid) VALUES(1073741824, 'My language is x', 1073741824);
SELECT level FROM t5_segdir;
SELECT docid FROM t5 WHERE t5 MATCH 'language' AND lid = 1073741824;
