repro.sql creates t1 with a partial index (WHERE b=1) on a, then runs `x IN / NOT IN (SELECT a FROM t1)`.
Buggy shell uses the partial index for the IN subquery, so it misses row a=2: NOT IN returns 'two|2' (should be empty) and IN returns only 1 (should be 1,2).
