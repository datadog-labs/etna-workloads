Reproducer (repro.sql): creates a WITHOUT ROWID table with a 2-column PK and a unique index, then runs `UPDATE t2 SET b=1 WHERE b=''`.
The injected bug only sets the first PK register to NULL (instead of the whole range) before opening the ephemeral table, leaving a VM register uninitialized.
Clean shell: no output, exit 0. Buggy shell: assertion failure `memIsValid(&r.aMem[ii])` in sqlite3VdbeExec (abort, status -6).
