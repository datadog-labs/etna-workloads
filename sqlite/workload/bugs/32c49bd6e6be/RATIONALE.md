# Rationale

## Changed: `alterFindTable()` in src/alter.c
Removed the block that calls `isRealTable(pParse, pTab, 2)` and
`isAlterableTable(pParse, pTab)`. This reverses the fix hunk that added those
checks to `alterFindTable()`. Before the fix, `alterFindTable()` only located
the table, so views, virtual tables and system tables were not rejected.
The fix moved the checks into the shared helper, which is why this hunk could
not be reversed textually: the helper and `isRealTable`'s `iOp` parameter
still exist in 3.54.1. The fix's other changes (auth in `alterFindCol`, the
`pFirst` token, `bAuth`) are left as they are.

## Oracle failures
- altercons-7.7: `ALTER TABLE v1 ALTER a SET NOT NULL` on a view no longer gives
  "cannot edit constraints of view". It runs on the view and trips the assertion
  `i<nCol` in `sqlite3ColumnIndex`.
- Cases 7.8 and 7.9 follow, since the run aborts at 7.7. They would also be
  wrong: sqlite_schema is no longer protected, and DROP NOT NULL on a view is
  no longer rejected.
