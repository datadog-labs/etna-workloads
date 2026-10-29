# Rationale

Only `ext/fts5/fts5_storage.c`, `fts5StorageContentlessDelete()` changed. It now matches the pre-fix version of the function.

- The fix added `fts5StorageLoadTotals(p, 1)` at the top of the function. I removed it. `sqlite3Fts5StorageDelete()` already loads the totals, so this is redundant. The fix's version of the call was new.
- The fix added a block that decodes the %_docsize blob and subtracts each column size from `p->aTotalSize[]`. I removed it. The pre-fix code read only the origin column.
- The fix added `p->nTotalRow--` after `sqlite3Fts5IndexContentlessDelete()`. I removed it.
- The fix changed `sqlite3_column_int64` to `sqlite3_column_int` for the origin. I restored `sqlite3_column_int64`. This is the pre-fix code.
- I kept `rc2` handling. The fix's diff shows it as new, but it doesn't affect the bug.

With these changes, deleting a row from a contentless_delete=1 table no longer decrements nTotalRow or aTotalSize. xRowCount() and xColumnTotalSize() then return stale values after a delete.

Failing oracle cases: fts5contentless5-3.3.1 (got `4 4`, expected `2 2`) and 3.3.2 (rowcount 4 and columntotalsize 16, expected 2 and 8).
