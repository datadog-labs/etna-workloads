CREATE VIRTUAL TABLE yy USING fts5(x, detail=none);
INSERT INTO yy VALUES('in if');
INSERT INTO yy VALUES('if');
SELECT rowid FROM yy('i*');
