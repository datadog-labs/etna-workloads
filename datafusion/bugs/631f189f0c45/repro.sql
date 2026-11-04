CREATE TABLE t(c1 BIGINT) AS VALUES (1::bigint), (2::bigint), (10::bigint);

SELECT
  c1,
  CASE WHEN c1 = 0 THEN 100.0
       ELSE ROUND((1.0 - (c1::numeric / c1)) * 100, 2)
  END AS rate
FROM t
WHERE (1.0 - (c1::numeric / c1)) * 100 < 95.0
ORDER BY c1;
