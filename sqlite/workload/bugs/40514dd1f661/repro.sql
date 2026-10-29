CREATE TABLE t1(x);
INSERT INTO t1 VALUES('xyz');
SELECT (VALUES((max(substr('abc',1,1),x))),(123),(456)) FROM t1;
