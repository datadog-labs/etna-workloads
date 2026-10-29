Reproducer (`repro.sql`) is test distinct-7.0/7.1 from the fix: a CTE `SELECT DISTINCT y FROM t5 ORDER BY y`
used in a correlated scalar subquery `count(*)` inside a 3-way CROSS JOIN.

- clean: prints `2|2|2`, exit 0.
- buggy: assertion failure `sqlite3Select: Assertion 'pSub->pGroupBy==0' failed` (abort, status -6),
  because the DISTINCT->GROUP BY transform no longer sets SF_Aggregate.
