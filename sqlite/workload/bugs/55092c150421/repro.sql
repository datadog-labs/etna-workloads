.dbconfig defensive off
CREATE VIRTUAL TABLE x1 USING fts5(z);
INSERT INTO x1 VALUES('a b c');
INSERT INTO x1 VALUES('b c d');
INSERT INTO x1 VALUES('c d e');
INSERT INTO x1 VALUES('d e f');
UPDATE x1_data SET block = X'00000000' WHERE id>100;
SELECT rowid FROM x1('c') WHERE rowid>1;
SELECT rowid FROM x1('c') WHERE rowid>1 ORDER BY rowid DESC;
