.mode list
.nullvalue NULL
SELECT GROUPING(g), list(v ORDER BY v)
FROM (VALUES (1, 3), (1, 1)) t(g, v)
GROUP BY g;
