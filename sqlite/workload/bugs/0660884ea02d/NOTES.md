`repro.sql` turns on recursive_triggers, builds a table with a partial unique index plus a second unique index and an AFTER DELETE trigger, then runs `REPLACE` twice (the insert-17.10/17.12 setup).

Clean shell: no error, and the final SELECT returns rows 1, 4 and 5.
Buggy shell: it aborts with `Assertion 'memIsValid(&aMem[pOp->p3])' failed` in sqlite3VdbeExec (exit -6). The bug is that the partial-index recheck tests `regIdx-1` instead of `regIdx` for NULL.
