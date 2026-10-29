CREATE TABLE c(a, lid);
INSERT INTO c VALUES('x', 0), ('y', NULL);
CREATE VIRTUAL TABLE f USING fts4(content=c, languageid=lid);
SELECT a, lid FROM f WHERE lid IN (0, 1);
