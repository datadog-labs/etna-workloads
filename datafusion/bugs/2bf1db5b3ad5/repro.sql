SELECT column1 AS v, NTILE(4) OVER (ORDER BY column1) AS bucket
FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10))
ORDER BY v;

SELECT column1 AS v, NTILE(3) OVER (ORDER BY column1) AS bucket
FROM (VALUES (1),(2),(3),(4),(5),(6),(7))
ORDER BY v;
