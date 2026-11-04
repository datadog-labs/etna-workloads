CREATE TABLE t AS VALUES
  (MAP {1: 10, 2: 20}),
  (MAP {3: 30}),
  (NULL);
SELECT column1, map_keys(column1) AS k, map_values(column1) AS v FROM t ORDER BY k;
SELECT map_keys(column1) IS NULL AS k_null, map_values(column1) IS NULL AS v_null FROM t ORDER BY 1, 2;
