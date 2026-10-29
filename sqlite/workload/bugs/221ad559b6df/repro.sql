CREATE TABLE t0(x INT);
CREATE TABLE t1(a INT, b TEXT);
CREATE INDEX t1a ON t1(a);
INSERT INTO t1(a,b) VALUES(9,'z');
SELECT b, a, (b, a) IN (('z',9)) AS p FROM t0 RIGHT JOIN t1 ON true;
SELECT b, a FROM t0 RIGHT JOIN t1 ON true WHERE (b,a) IN (('z',9));
