.mode list
.nullvalue NULL
pragma explain_output = optimized_only;
CREATE  TABLE  t2(c1 INTEGER);
CREATE  TABLE  t0(c1 DOUBLE);
INSERT INTO t0(c1) VALUES (0.1);
INSERT INTO t2(c1) VALUES (2);
SELECT * FROM t2 LEFT JOIN t0 ON true WHERE ((t0.c1<t2.c1) IS NULL);
