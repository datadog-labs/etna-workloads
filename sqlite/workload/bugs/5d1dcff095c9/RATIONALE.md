# Rationale

Fix hunk (src/delete.c): added `sqlite3TableLock(pParse, iDb, pTab->tnum, 1, pTab->zName)` before the OP_Clear in the "DELETE FROM tbl" truncate optimization.

Reversed in tree/src/delete.c by removing the same `sqlite3TableLock(...)` call just before the `OP_Clear` for the table b-tree (in the `HasRowid(pTab)` block). The code is otherwise identical in purpose, so OP_Clear again runs without taking the shared-cache write-lock on the table.

Oracle: sharedlock-2.4 fails (expected `1 {database table is locked: t2}`, got `0 {}`): a second shared-cache connection can read a table whose contents were deleted in an open transaction.
