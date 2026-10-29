.dbconfig defensive off
CREATE TABLE t1(a);
INSERT INTO t1 VALUES('Ebed-malech');
CREATE TABLE x(a);
PRAGMA writable_schema=ON;
CREATE VIRTUAL TABLE sqlite_stat1 USING fts5(a);
CREATE VIRTUAL TABLE t2 USING rtree(id,x,y);
SELECT * FROM t1;
