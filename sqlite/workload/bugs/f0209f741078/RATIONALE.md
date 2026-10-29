# Rationale

Hunk: `src/select.c`, `sqlite3GenerateColumnNames`-adjacent `sqlite3ColumnsFromExprList` (the "For columns use the column name" branch).

Reverses the fix's change `iCol>=0 ? pTab->aCol[iCol].zName : "rowid"` back to the pre-fix
unconditional `pTab->aCol[iCol].zCnName`. For a rowid column with no INTEGER PRIMARY KEY, `iCol`
is -1, so the code indexes `aCol[-1]` instead of naming the column "rowid" (ticket #3308).

Oracle: test/view.test view-19.1 (and 19.2/19.3) fail: the testfixture crashes/misbehaves at
view-19.1 (`CREATE VIEW ... SELECT rowid, * FROM t1`), where the view column should be named `rowid`.
