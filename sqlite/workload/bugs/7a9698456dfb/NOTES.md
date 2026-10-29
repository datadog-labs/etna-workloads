Reproducer (repro.sql) is update-17.10: a table with a partial index `ON t1(1) WHERE 3` (references no table column), then `UPDATE t1 SET x=2, y=3 WHERE 3`.
Clean shell prints `2|3`. Buggy shell aborts with assertion `pC->deferredMoveto==0` in sqlite3VdbeExec (exit -6), because the one-pass UPDATE uses OP_DeferredSeek that is never resolved before OP_Delete.
