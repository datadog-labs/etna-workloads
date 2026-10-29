# Ticket #3651 re-injection

Changes, all in `tree/src/alter.c` (the `sqlite_altertab_` prefix mechanism still exists in 3.54.1):

1. `sqlite3AlterBeginAddColumn`: `pNew->zName` is again `sqlite3DbStrDup(db, pTab->zName)` instead of
   `sqlite3MPrintf(db, "sqlite_altertab_%s", ...)`. Reverses the fix hunk at alter.c ~599. The comment
   about the prefix is also reverted.
2. `sqlite3AlterFinishAddColumn`: `zTab = pNew->zName;` instead of `&pNew->zName[16]`. Reverses the
   hunk at alter.c ~453. Needed so the table lookup matches the unprefixed name.

The build.c hunks (rename and the `altertab_` exemption in CreateIndex) are not reversed. The rename is
cosmetic, and the "may not be indexed" check in 3.54.1 only applies when `pTblName!=0`, so it has no
exemption to remove.

Effect: the temporary Table copy has the same name as the real table. Adding a UNIQUE column creates an
autoindex on the temp table that collides with the real table's index in the schema hash. Instead of the
error "Cannot add a UNIQUE column", this hits the assertion in `deleteTable`
(`pOld==pIndex || pOld==0`).

Failing oracle case: `alter-14.1` (assertion failure, crash). `alter-14.2` was not reached because the
test run aborted.
