CREATE TABLE t1(a INTEGER PRIMARY KEY);
INSERT INTO t1 VALUES(100),(200),(300);
ALTER TABLE t1 ADD COLUMN b DEFAULT 1234;
ALTER TABLE t1 ADD COLUMN c DEFAULT 'abcdef';
.session open main s
.session attach t1
DELETE FROM t1 WHERE a=300;
.session changeset cs.bin
.session close
CREATE TABLE cs(x BLOB);
INSERT INTO cs VALUES(readfile('cs.bin'));
SELECT hex(x) FROM cs;
