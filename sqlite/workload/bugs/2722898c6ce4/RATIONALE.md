# Rationale

Both hunks are in `tree/src/update.c`, `sqlite3Update()`, and reverse the two hunks of the fix.

1. Removed `j = -1;` in the `sqlite3IsRowid()` branch (fix hunk 1). Without it, j is -1 (the "not found" value from sqlite3ColumnIndex) and is no longer an explicit marker for ROWID. In the original code j was left at nCol, also an invalid index.
2. The authorizer call passes `pTab->aCol[j].zCnName` again instead of `j<0 ? "ROWID" : ...` (fix hunk 2). For a rowid update this reads `aCol[-1]`, an invalid pointer, which is the bug in the ticket.

Oracle: `auth-6.2` (`UPDATE t6 SET rowID=rowID+100` with an authorizer) crashes or gets a garbage column name instead of "ROWID". The check run stopped at auth-6.2.
