`repro.sql` runs `VALUES(300), (zeroblob(300) OVER win);`, a multi-row VALUES with a non-aggregate function that has an OVER clause.
Clean shell: `Parse error: zeroblob() may not be used as a window function` (exit 1).
Buggy shell: the function is treated as constant, so the assertion `memIsValid(&pMem[i])` fails in sqlite3VdbeExec (abort, exit 134).
