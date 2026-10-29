CREATE TABLE s(a REAL PRIMARY KEY, b);
CREATE TABLE u(a REAL PRIMARY KEY, b);
INSERT INTO s VALUES(7,2);
UPDATE s SET b=3;
INSERT INTO u VALUES(7,2);
.session open main ss
.session attach u
DELETE FROM u;
INSERT INTO u SELECT * FROM s;
.session changeset cs.bin
.shell od -An -tx1 cs.bin
.shell rm cs.bin
