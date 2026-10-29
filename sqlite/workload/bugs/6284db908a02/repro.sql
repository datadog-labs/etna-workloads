CREATE TABLE t1(a,b,c);
CREATE INDEX t1bc ON t1(b,c);
CREATE TABLE t2(a,b,c);
CREATE INDEX t2bc ON t2(b,c);
ANALYZE;
INSERT INTO sqlite_stat1 VALUES('t1','t1bc','1000000 10 9');
INSERT INTO sqlite_stat1 VALUES('t2','t2bc','100 10 5');
ANALYZE sqlite_master;
EXPLAIN QUERY PLAN
SELECT * FROM t1 WHERE likelihood(a=0, 0.03) ORDER BY a, b, c;
