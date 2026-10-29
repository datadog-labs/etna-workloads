CREATE TABLE t1(a TEXT, b TEXT);
INSERT INTO t1 VALUES(null,10),(0,10),(10,10);
CREATE INDEX t1ab ON t1(a,b);
SELECT quote(a), quote(b), '|' FROM t1 WHERE b in (SELECT a FROM t1) AND a=0;
