SELECT nanvl(1.0, NULL) AS a, nanvl(arrow_cast(1.0,'Float32'), CAST(NULL AS FLOAT)) AS b;
SELECT nanvl(x, y) FROM (VALUES (1.0, CAST(NULL AS DOUBLE)), (CAST('NaN' AS DOUBLE), 2.0), (3.0, 4.0)) t(x, y) ORDER BY 1;
