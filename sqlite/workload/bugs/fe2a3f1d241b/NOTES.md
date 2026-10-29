Reproducer (repro.sql): the upsert1-1000 case. A multi-row INSERT OR FAIL into a WITHOUT ROWID table, with an ON CONFLICT DO UPDATE clause, where the second row has a NULL in a unique column.

Clean shell: reports "NOT NULL constraint failed: t0.c0" and exits with status 1.
Buggy shell: the missing sqlite3MayAbort() call trips the assertion in sqlite3FinishCoding (`!pParse->isMultiWrite || sqlite3VdbeAssertMayAbort(...)`), and the shell aborts with SIGABRT.
