CREATE TABLE t1 (c1 integer, c2, PRIMARY KEY(c1 collate rtrim), UNIQUE(c2));
ALTER TABLE t1 RENAME c1 TO c3;
SELECT sql FROM sqlite_master;
