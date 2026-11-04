CREATE TABLE t1 AS SELECT * FROM (VALUES (11,1),(22,2),(33,3),(44,4)) v(t1_id,t1_int);
CREATE TABLE t2 AS SELECT * FROM (VALUES (11,1),(22,3),(33,3),(44,3),(55,5)) v(t2_id,t2_int);
SELECT t1_id,
  (SELECT regr_count(1.0, 1.0) FROM t2 WHERE t2.t2_int = t1.t1_int) AS r,
  (SELECT approx_distinct(t2.t2_id) FROM t2 WHERE t2.t2_int = t1.t1_int) AS d
FROM t1 ORDER BY t1_id;
SELECT t1_id FROM t1
WHERE (SELECT approx_distinct(t2.t2_id) FROM t2 WHERE t2.t2_int = t1.t1_int) = 0 ORDER BY t1_id;
