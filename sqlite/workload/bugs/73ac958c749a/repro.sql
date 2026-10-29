CREATE TABLE t1(a, b TEXT);
CREATE TABLE t2(c INTEGER PRIMARY KEY, d);
CREATE TABLE t3(e INTEGER PRIMARY KEY, f);
ANALYZE sqlite_schema;
INSERT INTO sqlite_stat1 VALUES('t1','idx1','600 6');
INSERT INTO sqlite_stat1 VALUES('t2','idx1','6 6');
INSERT INTO sqlite_stat1 VALUES('t3','idx2','6 6');
ANALYZE sqlite_schema;
INSERT INTO t1 VALUES(1, '123');
INSERT INTO t2 VALUES(123, 'one');
INSERT INTO t3 VALUES(123, 'two');
SELECT 'result' FROM t1, t2, t3
 WHERE t2.c=t1.b AND t2.d!='silly'
   AND t3.e=t1.b AND t3.f!='silly';
