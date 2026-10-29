# Rationale

Changed only `sqlite3_table_column_metadata()` in `tree/src/main.c`, reversing the
`src/main.c` hunk of the fix. (The sqlite.h.in, test1.c and test hunks are docs/test-only.)

Pre-fix code restored:
- `sqlite3IsRowid(zColumnName)` is tested first, before looking for a real column, and
  without `HasRowid(pTab)`. So a column literally named `rowid`/`oid`/`_rowid_`
  is shadowed by the rowid, and a WITHOUT ROWID table wrongly answers `rowid`
  successfully (as INTEGER primary key) instead of "no such table column".
- The `zColumnName==0` "table existence only" branch is removed, so a NULL column name is
  passed to `sqlite3IsRowid()` and crashes.
- The column-name loop is replaced by the equivalent `sqlite3ColumnIndex()` call
  already used in 3.54.1; a miss goes straight to error_out.

Oracle cases failing (test/colmeta.test): colmeta-24 (abc5 rowid should error, returns
INTEGER), colmeta-30/31/32 (abc6 columns named rowid/oid/_rowid_ return the rowid
metadata `INTEGER BINARY 0 1 0` instead of TEXT/REAL/BLOB), and colmeta-300/301 (NULL column name
crashes the process).
