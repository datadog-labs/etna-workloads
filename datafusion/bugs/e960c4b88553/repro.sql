CREATE TABLE t AS VALUES (1, 2), (3, 4);
CREATE TABLE s AS SELECT * FROM t x JOIN t y ON x.column1 = y.column1;
SELECT * FROM s;
CREATE VIEW v AS SELECT * FROM t x JOIN t y ON x.column1 = y.column1;
SELECT * FROM v;
