.dbconfig defensive off
CREATE VIRTUAL TABLE x1 USING fts5(c);
INSERT INTO x1 VALUES('yellow brick road');
INSERT INTO x1 VALUES('one two three');
INSERT INTO x1 VALUES('not at this hour');
UPDATE x1_data SET block = X'000000000103030003010187FFFFFF7F020101030101';
SELECT rowid FROM x1('two');
