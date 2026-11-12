.mode list
.nullvalue NULL
SELECT (SELECT 1), sum(1) OVER w WINDOW w AS (ORDER BY 1);
