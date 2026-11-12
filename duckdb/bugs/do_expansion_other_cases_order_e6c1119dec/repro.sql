.mode list
.nullvalue NULL
SELECT sum(x) FILTER (WHERE COLUMNS(*) IS NOT NULL)
FROM (VALUES (1, 10, 100), (2, NULL, 200), (3, 30, NULL)) v(x, a, b);
SELECT coalesce(sum(x) FILTER (WHERE COLUMNS(*) IS NOT NULL), 0)
FROM (VALUES (1, 10, 100), (2, NULL, 200), (3, 30, NULL)) v(x, a, b);
SELECT sum(x) FILTER (WHERE COLUMNS(*) IS NOT NULL) OVER ()
FROM (VALUES (1, 10, 100), (2, NULL, 200), (3, 30, NULL)) v(x, a, b);
SELECT g, sum(x) FILTER (WHERE COLUMNS(*) IS NOT NULL) AS s
FROM (VALUES (1, 1000, NULL, 1), (1, 1, 1, 1), (2, 100, 1, 1)) v(g, x, a, b)
GROUP BY g
ORDER BY sum(x) FILTER (WHERE COLUMNS(*) IS NOT NULL);
