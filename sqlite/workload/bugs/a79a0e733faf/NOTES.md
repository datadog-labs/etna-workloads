Reproducer (repro.sql) is distinct2-2040: a table with index t2(a,b), a one-row t3, ANALYZE,
then `SELECT DISTINCT a, b, x FROM t3 CROSS JOIN t2 ORDER BY a`.
Clean returns 4 rows (one|0, one|1, two|0, two|1); buggy returns only 2 (one|0, two|0),
because the ORDER BY column count is confused with the DISTINCT column count in the
WHERE_DISTINCT_ORDERED skip-ahead optimization.
