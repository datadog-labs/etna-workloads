Reproducer (repro.sql): the upstream test distinct2-1000 translated to SQL. It runs a
`SELECT DISTINCT y FROM t1, t2 WHERE b=x AND b<>-1` join before and after ANALYZE.

After ANALYZE, the skip-ahead-distinct optimization is applied to the outer loop of a
join whose inner loop contributes no result columns. The clean shell prints `1` twice.
The buggy shell prints `1` only once, so the second query returns no rows.
