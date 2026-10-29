`repro.sql` builds a UNION ALL view and runs `SELECT count(*) FROM t3 ORDER BY sum(a)` (plus HAVING variants).
The injection removes the `pOrderBy` check from countOfViewOptimization, so the optimization applies and generates bad bytecode.
Clean: prints 4 and 4, exit 0. Buggy: assertion `pC!=0` fails in sqlite3VdbeExec (abort, status -6).
