repro.sql: creates a trigger whose body is `UPDATE t1 SET x=x FROM (SELECT*)`, then runs `ALTER TABLE t1 RENAME TO x`.

Clean shell: `Error near line 5: error in trigger r1: no tables specified` (exit 1).
Buggy shell: aborts with assertion failure `pTab->nCol>0` in lookupName (exit -6/SIGABRT), because the injection removes early-exit-on-error checks.
