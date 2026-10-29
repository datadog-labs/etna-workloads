Reproducer (`repro.sql`): table with INTEGER PRIMARY KEY, a unique expression index on abs(x), then
`DELETE ... WHERE abs(x) IS NULL OR abs(x)<130` (the intpkey-17.1 case, minus the earlier setup).

Clean shell: deletes row 123 and prints `248|giraffe`.
Buggy shell: the deferred seek on the main table isn't finished before the delete, so it aborts with
`Assertion pC->deferredMoveto==0 failed` in sqlite3VdbeExec (exit status -6).
