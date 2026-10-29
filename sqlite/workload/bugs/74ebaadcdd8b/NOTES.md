repro.sql: LEFT JOIN where the RHS index is on t1(c,b) and the ON clause is `c = d AND b IN (...)`.
Since d is NULL, the IN loop is never opened, but the loop end still runs OP_IfNoHope/OP_Next on the unopened cursor.
Clean shell prints `|1|||`. Buggy shell aborts with assertion `pC->eCurType==CURTYPE_BTREE` in sqlite3VdbeExec (exit -6).
