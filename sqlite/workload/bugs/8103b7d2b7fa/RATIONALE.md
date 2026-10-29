# Rationale

Bug: the INSERT xfer optimization fired even when source and destination
tables had different CHECK constraints (ticket #2252), so rows bypassed the
destination's CHECK.

Fix hunk reversed: the `sqlite3ExprCompare(pSrc->pCheck, pDest->pCheck)` test
in `xferOptimization()`. In 3.54.1 that comparison lives in
`xferCompatibleCheck()` (src/insert.c) as `sqlite3ExprListCompare(...)`. I
removed that comparison, so tables with differing CHECK constraints are
treated as compatible. The later-added rowid-in-CHECK guard is left intact.
The other fix hunks (HAVING/OFFSET tests, asserts) are not part of the
behavioral bug.

Oracle: 16 of 94 cases in test/insert4.test fail, including insert4-1.1/1.2
(INSERT INTO t1 SELECT * FROM t2 succeeds despite check(b>a) violation
instead of "constraint failed"), 2.x, 3.4.2, 6.6/6.7 and 12.x
(CHECK constraint failed / missing).
