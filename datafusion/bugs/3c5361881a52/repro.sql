SELECT g, COUNT(a) FILTER (WHERE b < 1) AS count_a
FROM (VALUES (0, 1, CAST(NULL AS INT)), (0, 2, 2)) AS t(g, a, b)
GROUP BY g;

SELECT g, corr(x, y) FILTER (WHERE b < 1) AS r
FROM (VALUES
  (0, 1.0, 1.0, CAST(NULL AS INT)),
  (0, 2.0, 2.0, CAST(NULL AS INT)),
  (0, 3.0, 4.0, 2)
) AS t(g, x, y, b)
GROUP BY g;
