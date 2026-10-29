repro.sql builds t8 (99 rows), indexes t8(a,c), runs ANALYZE, then runs
`SELECT DISTINCT a, b, c FROM t8 WHERE b=3`. That enables the skip-ahead-distinct
optimization. With the bug, the continue label is resolved before the skip-ahead
code, so the loop skips the row-advance and the query returns no rows.
Clean shell: `1|3|1`. Buggy shell: no output. Exit status is 0 on both.
