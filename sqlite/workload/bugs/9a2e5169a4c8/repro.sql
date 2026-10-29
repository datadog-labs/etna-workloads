CREATE TABLE t9a(a,b,c);
CREATE INDEX t9a_ab ON t9a(a,b);
CREATE TABLE t9b(x,y);
ANALYZE sqlite_master;
INSERT INTO sqlite_stat1 VALUES('t9a','t9a_ab','1000000 250000 1');
ANALYZE sqlite_master;
EXPLAIN QUERY PLAN
SELECT * FROM t9a WHERE b IN (SELECT x FROM t9b WHERE y!=5);
