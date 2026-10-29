Reproducer (`repro.sql`): with t2(x,y) and an index on t2(x), runs EXPLAIN QUERY PLAN on
`SELECT * FROM t1 WHERE EXISTS (SELECT y FROM t2 WHERE t1.x!=t2.x)` (eqp-3.3.3).
Clean shell: `SCAN t2 EXISTS USING COVERING INDEX t2i1`. Buggy shell: `SCAN t2 EXISTS`
(the columns-used mask isn't recomputed after exists-to-join, so the covering index isn't
chosen and an unneeded table cursor is opened).
