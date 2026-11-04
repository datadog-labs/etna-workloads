SELECT g, first_value(a ORDER BY a) FILTER (WHERE b < 1) AS fv
FROM (VALUES (0, 10, CAST(NULL AS INT)), (0, 20, 2)) AS t(g, a, b)
GROUP BY g ORDER BY g;

SELECT g, last_value(a ORDER BY a) FILTER (WHERE b < 1) AS lv
FROM (VALUES (0, 10, CAST(NULL AS INT)), (0, 20, 2)) AS t(g, a, b)
GROUP BY g ORDER BY g;
