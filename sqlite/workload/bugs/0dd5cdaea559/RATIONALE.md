# Rationale

Two changes in `tree/src/build.c`, reversing the two implementation hunks of the fix (the vdbeaux.c hunk only relaxes a debug assert and is not needed to restore the bug):

1. `sqlite3StartTable`: `sqlite3BeginWriteOperation(pParse, 1, iDb)` -> `(pParse, 0, iDb)`. This reverses the first build.c hunk. CREATE TABLE no longer opens a statement journal.
2. `sqlite3EndTable` (CREATE TABLE AS branch): removed `sqlite3MayAbort(pParse)` before the `OP_OpenWrite`. This reverses the second hunk. Together with (1), the statement is not marked as possibly aborting.

The result is that if the SELECT aborts partway (e.g. `zeroblob(2e20)` -> "string or blob too big"), the partial sqlite_master/btree changes are not rolled back.

## Oracle failures
- table-18.2: after the failed CREATE TABLE AS inside BEGIN, `PRAGMA integrity_check` reports "Page 2011: never used" instead of `ok`.
- table-19.1: a later table listing contains a leftover extra entry, which is a downstream effect of the same corruption.
