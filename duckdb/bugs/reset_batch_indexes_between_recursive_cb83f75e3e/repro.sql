.mode list
.nullvalue NULL
SET threads=1;
SET threads=4;
SET preserve_insertion_order=true;
WITH RECURSIVE
df(a) AS MATERIALIZED (VALUES (1), (2), (3)),
RecursiveCTE AS (
	SELECT Number FROM df t(Number)
	UNION ALL
	SELECT Number + (SELECT a FROM df OFFSET 2 LIMIT 1) + 1 AS new
	FROM RecursiveCTE
	WHERE new < 10
)
SELECT * FROM RecursiveCTE;
