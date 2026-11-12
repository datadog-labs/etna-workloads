.mode list
.nullvalue NULL
SELECT 1 AS one FROM (
	values
	(1,2),
	(3,2)
) t(a, b)
HAVING 1 < 2;
