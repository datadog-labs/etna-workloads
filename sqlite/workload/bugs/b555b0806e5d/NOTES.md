Reproducer (repro.sql) is the window1-30.0 test: a window function on the LHS of NOT BETWEEN (the expression gets duplicated), plus a second window derived from a named window.
Clean shell prints `1|1`. Buggy shell aborts with assertion `pOp->p3>0` in sqlite3VdbeExec (exit -6), because sqlite3WindowDup no longer copies regResult.
