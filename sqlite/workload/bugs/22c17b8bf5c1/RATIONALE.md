# Rationale

Fix (56ef98a) made `sqlite3SetString()` a plain string copy, because the old
printf-style version let callers pass arbitrary text as the format string.
In 3.54.1 `sqlite3SetString()` is already the plain-copy form, and `execSql()` in
src/vacuum.c still calls `sqlite3SetString(pzErrMsg, db, sqlite3_errmsg(db))`.

Changes (reversing the fix's malloc.c and sqliteInt.h hunks):
- src/malloc.c: `sqlite3SetString(char**, sqlite3*, const char *zFormat, ...)` formats
  through `sqlite3VMPrintf()` again, instead of `sqlite3DbStrDup()`.
- src/sqliteInt.h: prototype restored to variadic.

The other hunks (sqlite3VdbeError, corruptSchema, etc.) are refactors that
3.54.1 has already moved past, and nothing else was changed.

Effect: VACUUM of a database with a corrupt schema such as
`CREATE TABLE [M%s%s%s...` passes the error text "unrecognized token: "[M%s%s..."
as a format, so the `%s` are expanded (garbage, or a crash on missing varargs).
Oracle case misc4-7.1 fails: the run stops there (its output ends at "misc4-7.1...");
the result differs from the expected `{1 {unrecognized token: "[M%s%s..."}}`.
