.mode list
.nullvalue NULL
CREATE TABLE t1 (c1 INTEGER, c2 INTEGER[]);
INSERT INTO t1 VALUES (1, NULL), (2, NULL);
SELECT t1.c1, s3.a1
FROM t1, (
	SELECT t1.c1 AS a0, max(s1.v1) AS a1, max(t1.c1)::BIGINT AS a2, count(DISTINCT t1.c1) AS a3
	FROM t1
	JOIN (SELECT c1 AS k1, [c1] AS v1 FROM t1) AS s1 ON (t1.c1 = s1.k1)
	JOIN (SELECT DISTINCT c1 FROM t1) AS s2 ON (t1.c1 = s2.c1)
	GROUP BY t1.c1
) AS s3
WHERE t1.c1 = s3.a0
ORDER BY ALL;
