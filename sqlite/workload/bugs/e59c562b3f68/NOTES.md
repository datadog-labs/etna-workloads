repro.sql runs the window1-33.2 query: a sub-select using DISTINCT plus a window function, with an ORDER BY identical to its select list.
Clean shell prints `6|1` (exit 0). Buggy shell aborts with an assertion failure (`memIsValid(pRec)` in sqlite3VdbeExec), exit status -6.
The cause is that the DISTINCT-to-GROUP-BY optimization is wrongly applied when the select has window functions (the fix adds `p->pWin==0`).
