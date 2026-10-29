Reproducer (`repro.sql`): a window-function query with LIMIT
(`SELECT a, sum(a) OVER (ORDER BY a) FROM t1 LIMIT 2`).
The bug passes 0 instead of iBreak to selectInnerLoop for the window inner loop, so the LIMIT jump has no target.
Clean shell prints the 2 rows (1|1, 2|3). Buggy shell aborts with an assertion failure in resolveP2Values (p2>0).
