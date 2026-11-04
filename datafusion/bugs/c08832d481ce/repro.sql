SELECT
  log(a, 1) AS l1,
  log(a, a) AS la,
  log(a, power(a, b)) AS lp,
  power(a, 0) AS p0,
  power(a, log(a, b)) AS pl
FROM (VALUES (NULL::double, 2.0::double), (2.0, 3.0)) AS t(a, b)
ORDER BY b;
