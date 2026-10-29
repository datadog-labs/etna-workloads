repro.sql runs PRAGMA foreign_key_check on a table whose foreign key lists column `a` 14 times (more FK columns than table columns).
Clean shell prints `t1|1|t0|0`. Buggy shell (register allocation removed) aborts with an assertion failure in sqlite3VdbeExec (`pOp->p3>0 && pOp->p3<=...`), exit status -6 (SIGABRT).
