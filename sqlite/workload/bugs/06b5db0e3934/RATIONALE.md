# Rationale

Fix 06b5db0e39 stopped passing arbitrary strings as the printf format to the error setter.

## Hunks changed
- `src/vdbeblob.c` (sqlite3_blob_open, `blob_open_out:`): fix changed `sqlite3Error(db, rc, zErr)` to `(zErr ? "%s" : 0), zErr`. In 3.54.1 the call is `sqlite3ErrorWithMsg(db, rc, (zErr ? "%s" : 0), zErr)`; reverted to `sqlite3ErrorWithMsg(db, rc, zErr)`, so zErr (e.g. `no such column: "... %s%s"`) is used as a format string.
- `src/vtab.c` (sqlite3_declare_vtab): same hunk; reverted to `sqlite3ErrorWithMsg(db, SQLITE_ERROR, sParse.zErrMsg)`.
- The fix's first vdbeblob hunk (`sqlite3MPrintf(db, sqlite3_errmsg(db))` in the retry loop) no longer exists in 3.54.1 (the code was restructured), so it is not reverted.

## Oracle failures
`incrblob-9.1` crashes testfixture (segfault on `%s%s` in the column name) after the 8.x tests. The vtab1-17.1 case does not fail on this build (the error message there is not reached with the format specifiers).
