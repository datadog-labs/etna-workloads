.dbconfig defensive off
CREATE VIRTUAL TABLE Table0 USING fts3();
INSERT INTO Table0_segdir VALUES(1,NULL,1,NULL,NULL,NULL);
SELECT * FROM Table0 WHERE Table0 MATCH 'a';
INSERT INTO Table0(Table0) VALUES('optimize');
