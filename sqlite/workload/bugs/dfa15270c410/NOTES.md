repro.sql is the gencol1-8.10 case (ticket 4fc08501f4e56692): a table with generated column c0 that depends on generated column c1, plus a CHECK constraint on c1, then two INSERTs and a SELECT.

- Clean shell: prints `1|1|0` and `1|1|99`, exit 0.
- Buggy shell: aborts with `Assertion 'memIsValid(&aMem[pOp->p1])' failed` in sqlite3VdbeExec (exit -6).
  The buggy build computes c1 inside CHECK-constraint branch code that may not be taken, so a register is read uninitialised.
