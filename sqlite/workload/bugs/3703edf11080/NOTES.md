repro.sql runs a FILTER aggregate over a flattened subquery (`FROM (SELECT * FROM t1)`).
Without the fix, substExpr() doesn't rewrite column references inside FILTER clauses when the subquery is flattened.
Clean shell prints 1 / 1 1 / 0 1. Buggy shell aborts with assertion `pC!=0` in sqlite3VdbeExec (exit -6).
