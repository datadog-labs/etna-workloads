# Rationale

Change in `tree/src/vdbeaux.c`:

1. `sqlite3VdbeAddParseSchemaOp()`: removed the trailing `sqlite3MayAbort(p->pParse);`.
   This reverses fix hunk 1, which added that call so that every statement using
   OP_ParseSchema gets a statement journal (OP_ParseSchema can fail, e.g. on a
   malformed schema entry such as `CREATE VIEW IF NOT EXISTS IF AS SELECT null`).
   Without it, `Parse.mayAbort` is not set by OP_ParseSchema and the statement may run
   with no statement journal, so a failed schema reparse cannot be rolled back cleanly
   inside a transaction (verified manually: `BEGIN; CREATE TABLE t0; CREATE VIEW IF NOT
   EXISTS IF AS SELECT null;` leaves the bogus state behind).

Fix hunk 2 (`opcode==OP_ParseSchema && pOp->p4.z==0` -> `opcode==OP_ParseSchema` in
`sqlite3VdbeAssertMayAbort`) is left in its fixed form. It is a debug-only consistency
check; keeping it is what lets the missing `sqlite3MayAbort()` be detected.

## Oracle failures
The debug testfixture aborts in `sqlite3FinishCoding`:
`Assertion '!pParse->isMultiWrite || sqlite3VdbeAssertMayAbort(v, pParse->mayAbort)' failed`
on the very first test (view-1.0), so all view.test oracle cases (including view-29.x)
fail as an incomplete run. With both hunks reverted the oracle did not fail, because the
view-29 tests run in autocommit, where no statement journal is used anyway.
