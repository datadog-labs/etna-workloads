Reproducer (`repro.sql`): with `recursive_triggers=1`, an AFTER DELETE trigger on t9 deletes from t9 again (`WHERE b=old.a`), then `DELETE FROM t9 WHERE b=4` runs (triggerC-9.2).

The injection removes the pessimistic default `aColmask[0] = 0xffffffff`, so the recursively coded trigger program's old-column mask is too small while it is still being coded.

Clean shell: prints `world|1` and then rows 1 2 3 4, exit status 0.
Buggy shell: aborts with the assertion `memIsValid(&aMem[pOp->p1])` in sqlite3VdbeExec, exit status -6 (SIGABRT).
