Reproducer (repro.sql): func-34.10. A CHECK constraint calls datetime() with 49 arguments, and the INSERT then selects the rows.
With the bug, sqlite3VdbeReleaseRegisters() does not skip its mask handling when N>31, and that corrupts the register-validity tracking in debug builds.
Clean shell: prints 1 and 2, exit 0.
Buggy shell: aborts with `Assertion 'memIsValid(pCtx->argv[i])' failed` in sqlite3VdbeExec (exit -6).
