.mode list
.nullvalue NULL
CREATE TABLE t0(c0 BOOLEAN, c1 INT, c2 INT);
INSERT INTO t0 SELECT false, r, NULL FROM range(1, 23) t(r);
INSERT INTO t0 VALUES (false, 23, -1);
SELECT count(*) FROM t0 RIGHT JOIN (SELECT 1 FROM range(100)) s
  ON ((EXISTS (SELECT 1 FROM t0 WHERE t0.c2 < 0)) NOT BETWEEN (t0.c2 = t0.c1) AND t0.c0);
