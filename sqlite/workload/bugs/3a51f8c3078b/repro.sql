.dbconfig defensive off
CREATE VIRTUAL TABLE ft USING fts5(x, content=, contentless_delete=1);
BEGIN;
INSERT INTO ft VALUES('one one one');
INSERT INTO ft VALUES('two two two');
INSERT INTO ft VALUES('three three three');
INSERT INTO ft VALUES('four four four');
INSERT INTO ft VALUES('five five five');
INSERT INTO ft VALUES('six six six');
INSERT INTO ft VALUES('seven seven seven');
INSERT INTO ft VALUES('eight eight eight');
INSERT INTO ft VALUES('nine nine nine');
COMMIT;
DELETE FROM ft WHERE rowid=3;
UPDATE ft_data SET block = x'0400000000000000' WHERE id = (SELECT max(id) FROM ft_data);
SELECT rowid FROM ft('two');
UPDATE ft_data SET block = x'0400000000000000' WHERE id = (SELECT max(id) FROM ft_data);
DELETE FROM ft WHERE rowid=8;
