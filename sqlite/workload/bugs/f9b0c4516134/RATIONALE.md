# Rationale

Single change, in `convertToWithoutRowidTable()` in `tree/src/build.c`, reversing the one implementation hunk of the fix:

- Removed the `if( IN_RENAME_OBJECT ){ sqlite3RenameTokenRemap(pParse, pList->a[0].pExpr, &pTab->iPKey); }` block. Without it the synthesized PRIMARY KEY column token is never remapped to the `iPKey` token, so RENAME COLUMN can't find it in the rewritten PRIMARY KEY clause.
- Moved `pTab->iPKey = -1;` back to after `sqlite3CreateIndex()` (it now sits after `sqlite3PrimaryKeyIndex()`), as in the pre-fix code, instead of before the call.

Oracle failures: altertab-18.1.1 (ALTER TABLE ... RENAME COLUMN on a WITHOUT ROWID table with an INTEGER PRIMARY KEY column errors) and altertab-18.1.2 (the schema SQL is not updated).
