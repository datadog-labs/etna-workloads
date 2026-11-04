SELECT
  column1,
  covar_pop(column2, column3) OVER (ORDER BY column1 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS cp,
  covar_samp(column2, column3) OVER (ORDER BY column1 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS cs,
  corr(column2, column3) OVER (ORDER BY column1 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS c
FROM (VALUES (1, 10.0, 5.0), (2, NULL, NULL), (3, NULL, NULL), (4, 30.0, 10.0), (5, 40.0, 20.0), (6, 50.0, 10.0))
ORDER BY column1;

SELECT
  column1,
  var_pop(column2) OVER (ORDER BY column1 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS vp,
  var_samp(column2) OVER (ORDER BY column1 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS vs,
  stddev_samp(column2) OVER (ORDER BY column1 ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS ss
FROM (VALUES (1, 10.0), (2, NULL), (3, NULL), (4, 30.0), (5, 40.0))
ORDER BY column1;
