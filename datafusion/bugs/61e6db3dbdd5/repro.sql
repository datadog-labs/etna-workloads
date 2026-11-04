SELECT c1, var_samp(c2) FILTER (WHERE c2 > 5) FROM (VALUES (1, 1.0), (1, 2.0), (2, 9.0), (2, 8.0), (3, 7.0)) AS t(c1, c2) GROUP BY c1 ORDER BY c1;
SELECT c1, stddev_samp(c2) FILTER (WHERE c2 > 5) FROM (VALUES (1, 1.0), (1, 2.0), (2, 9.0), (2, 8.0), (3, 7.0)) AS t(c1, c2) GROUP BY c1 ORDER BY c1;
