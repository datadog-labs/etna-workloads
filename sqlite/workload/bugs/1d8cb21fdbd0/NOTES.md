`repro.sql` is test 1.4 of tkt-7bbfb7d442. A trigger runs a correlated UPDATE whose subqueries use OP_Once. It fires several times from a single `INSERT ... SELECT 1 UNION SELECT 2 UNION SELECT 3`.

The injection removes the memset that clears a trigger frame's OP_Once flags. The flags then hold stale or uninitialised data.

- clean: prints `1|I`, `2|II`, `3|III`, exit 0.
- buggy: aborts with `Assertion 'memIsValid(pRec)' failed` in sqlite3VdbeExec (exit status -6).
