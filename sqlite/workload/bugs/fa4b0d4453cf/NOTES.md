Reproducer: `repro.sql` runs the filter1-7.1 query `SELECT max(a), max(a) FILTER (WHERE b<12345), b FROM t1`.

Clean shell: prints `444||120000`, exit 0.
Buggy shell: aborts with the assertion `memIsValid(&aMem[pOp->p1])` in sqlite3VdbeExec. The injected bug emits the "magnet" register copy even when an unfiltered max() already populates the registers, so it copies an uninitialized register.
