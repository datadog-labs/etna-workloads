CREATE VIRTUAL TABLE t6 USING fts4(languageid=lid);
INSERT INTO t6 VALUES('I belong to language 0!');
INSERT INTO t6(content, lid) VALUES('row belong to language N!', 1073741824);
SELECT level FROM t6_segdir;
SELECT docid FROM t6 WHERE t6 MATCH 'belong';
SELECT docid FROM t6 WHERE t6 MATCH 'belong' AND lid=1073741824;
