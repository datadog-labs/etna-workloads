create table foo (a int, b int) as values (1, 2), (3, 4), (5, 6), (null, null), (6, null), (null, 7);
SELECT a, b, CASE WHEN NULLIF(NVL(a, 0) >= 0, FALSE) THEN b END AS r1 FROM foo ORDER BY a, b;
SELECT a, b, CASE WHEN NULLIF(NVL(a, 0) >= 0, TRUE) THEN b END AS r2 FROM foo ORDER BY a, b;
SELECT a, b, CASE WHEN NULLIF(a >= 0, FALSE) THEN b END AS r3 FROM foo ORDER BY a, b;
