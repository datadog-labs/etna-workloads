SELECT
  t1.v1,
  SUM(t1.v1) OVER w + 1
FROM
  generate_series(1, 5) AS t1(v1)
WINDOW
  w AS (ORDER BY t1.v1)
ORDER BY t1.v1;
