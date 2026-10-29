The bug is in `sqlite3_table_column_metadata()`. With the bug, a NULL column name is passed to `sqlite3IsRowid()`, which dereferences it. The fix made NULL mean "check that the table exists".

`repro.sql` calls that function with a NULL column name through the shell's `.import`. The import target `t` already exists, so the shell checks for it with a NULL column name.

- clean: prints `done`, exit 0.
- buggy: segfaults (exit 139) with no output.

This corresponds to colmeta-301 in the test. The other listed colmeta failures involve the rowid, oid and _rowid_ names on WITHOUT ROWID tables and on tables with columns named rowid, oid or _rowid_. I did not reproduce those separately.
