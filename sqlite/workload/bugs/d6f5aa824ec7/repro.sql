.dbconfig defensive off
CREATE VIRTUAL TABLE ft USING fts5(x, content=, contentless_delete=1);
BEGIN;
INSERT INTO ft VALUES('one one one');
INSERT INTO ft VALUES('two two two');
INSERT INTO ft VALUES('three three three');
INSERT INTO ft VALUES('four four four');
INSERT INTO ft VALUES('five five five');
COMMIT;
DELETE FROM ft WHERE rowid=3;
UPDATE ft_data SET block = unhex('0400000000000001' || '0102030401020304010203040102030401020304010203040102030401020304')
  WHERE id = (SELECT max(id) FROM ft_data);
DELETE FROM ft WHERE rowid=1;
SELECT rowid FROM ft('two');
