CREATE TABLE src(x,y,z, CONSTRAINT c1 CHECK(rowid<=5));
CREATE TABLE dest(x,y,z, CONSTRAINT c2 CHECK(rowid<=5));
INSERT INTO src(x) VALUES(22),(33),(44);
INSERT INTO dest(x) VALUES(55),(66),(77);
INSERT INTO dest SELECT * FROM src;
SELECT rowid, x FROM dest;
PRAGMA integrity_check;
