repro.sql runs a DISTINCT ... ORDER BY query over a RIGHT JOIN (where-18.1rj).
Clean shell prints `1`. Buggy shell aborts (exit -6) with assertion
`pOp->p1!=SQLITE_INTERNAL` in sqlite3VdbeExec, because the RIGHT JOIN loop's
"continue" label (addrCont) is no longer resolved before the subroutine's Return.
