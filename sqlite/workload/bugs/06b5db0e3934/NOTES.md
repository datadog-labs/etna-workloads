# Reproducer notes

`incrblob-9.1` exercises the bug fixed in `sqlite3_blob_open()` (an error
message string passed directly as a printf format to `sqlite3Error()`), but
that code path isn't reachable from the plain `sqlite3` shell (there's no
`.incrblob` dot-command / no C API access). The fix commit
(06b5db0e3934d8a3dad7ca44257cb4f3c02b4208) patches three call sites with the
same pattern; `injection.patch` re-breaks the `vtab.c` one as well
(`sqlite3_declare_vtab()`'s error path), which *is* reachable from SQL via a
`CREATE VIRTUAL TABLE` that fails inside the module's `xConnect`/`xCreate`.

`repro.sql` declares an rtree virtual table with two columns both named
`a%s%s%s%s`. `sqlite3_declare_vtab()` fails with "duplicate column name:
a%s%s%s%s", and that message string (containing `%s` sequences) is reported
via `sqlite3Error(db, SQLITE_ERROR, zErr)`.

- On `sqlite3-clean`, the message is passed as a `%s`-escaped format string,
  so it's printed as a literal string: a normal `Error near line 1:
  duplicate column name: a%s%s%s%s` error, exit status 1.
- On `sqlite3-buggy`, the message is passed directly as the format string
  to the underlying vprintf-style formatter, which tries to consume `%s`
  arguments that don't exist, reading garbage/invalid pointers and crashing
  with a segmentation fault (exit status 139).
