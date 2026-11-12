.mode list
.nullvalue NULL
CREATE TABLE src(a INTEGER, b INTEGER, v INTEGER);
INSERT INTO src VALUES (1, 1, 10), (1, 2, 20);
SELECT
	SUM(v) OVER (PARTITION BY a, a) AS w_aa,
	SUM(v) OVER (PARTITION BY a, b) AS w_ab
FROM src
ORDER BY b;
