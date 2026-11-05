CREATE TABLE t (u1 int, u2 int);
INSERT INTO t SELECT (i*7919) % 10000, i FROM generate_series(0,9999) i;
CREATE UNIQUE INDEX t_u2 ON t(u2);
CREATE UNIQUE INDEX t_u1 ON t(u1);
ANALYZE t;
SET enable_material = off;
EXPLAIN
SELECT t1.u1 FROM t t1 LEFT JOIN
  (SELECT *, 42 AS phv FROM t t2) ss ON t1.u2 = ss.u2
WHERE ss.u1 = ss.phv AND t1.u1 < 1000;
EXPLAIN
SELECT t1.u1 FROM t t1 LEFT JOIN
  (SELECT *, 42 AS phv FROM t t2) ss ON t1.u2 = ss.u2
WHERE ss.u1 = ss.phv AND t1.u1 < 100;
EXPLAIN
SELECT * FROM t t1 LEFT JOIN
  (SELECT *, 42 AS phv FROM t t2) ss ON t1.u2 = ss.u2
WHERE ss.u1 = ss.phv;
