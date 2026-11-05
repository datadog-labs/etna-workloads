# Rationale

Changed hunk: `src/backend/access/transam/xact.c`, `DefineSavepoint()`.
Traces to the fix.patch hunk in `DefineSavepoint` that added a `TBLOCK_IMPLICIT_INPROGRESS` case.
That case raises "SAVEPOINT can only be used in transaction blocks".
I removed that error case and let `TBLOCK_IMPLICIT_INPROGRESS` fall into the normal `TBLOCK_INPROGRESS`/`TBLOCK_SUBINPROGRESS` subtransaction-start path.
A SAVEPOINT inside a multi-statement Query string is therefore accepted in the implicit transaction block again, instead of being rejected.
This brings back the savepoint-in-multi-statement-string mishandling the fix removed.

I did not touch the RELEASE SAVEPOINT and ROLLBACK TO SAVEPOINT hunks.

Failing oracle case: src/test/regress||transactions
