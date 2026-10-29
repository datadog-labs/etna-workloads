# Rationale

Bug (596d059a): ALTER TABLE RENAME / RENAME COLUMN run nested SQL that calls
scalar functions (sqlite_rename_table() etc.) that can raise errors, but no
statement transaction was opened (Parse.mayAbort never set), so a failing
rename could leave a partial schema update behind.

## Changes
- `src/alter.c`, sqlite3AlterRenameTable(): removed `sqlite3MayAbort(pParse)`
  (reverses the fix's added call; comment restored to the pre-fix wording).
- `src/alter.c`, sqlite3AlterRenameColumn(): removed `sqlite3MayAbort(pParse)`
  before `sqlite3NameFromToken()` (reverses the fix's added call).
- Since 3.54.1 covers the case from other paths (the bug was fixed twice), the
  same defect is restored there too:
  - `src/vdbeaux.c` sqlite3VdbeAddFunctionCall(): `sqlite3MayAbort()` is only
    called when `pParse->nested==0`. The nested ALTER SQL calls functions
    (sqlite_rename_*, LIKE) and in 2019 function calls did not mark mayAbort.
  - `src/vdbeaux.c` sqlite3VdbeAddParseSchemaOp(): removed
    `sqlite3MayAbort()`; ALTER's renameReloadSchema() emits OP_ParseSchema,
    which in 2019 did not mark mayAbort either.

## Oracle
Built with SQLITE_DEBUG, `sqlite3VdbeAssertMayAbort()` (which already treats
OP_Function as able to abort, the analogue of the fix's vdbeaux.c hunk) fires
in sqlite3FinishCoding for ALTER TABLE: the run aborts at altertab3-1.1 with
`Assertion '!pParse->isMultiWrite || sqlite3VdbeAssertMayAbort(...)' failed`, so
the remaining altertab3 cases (including 4.x) don't complete. Without the
assert, usesStmtJournal would be 0 for the ALTER, as in the original bug.
