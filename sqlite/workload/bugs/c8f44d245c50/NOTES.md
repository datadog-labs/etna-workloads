## What it does

`repro.sql` creates an FTS5 table, inserts one row, then calls the built-in
`snippet()` auxiliary function three times, each time passing `NULL` for one
of the text arguments (`zOpen`, `zClose`, `zEllips` respectively):

```sql
SELECT snippet(p1, 0, '[', ']', NULL, 6) FROM p1('x');
SELECT snippet(p1, 0, NULL, ']', '...', 6) FROM p1('x');
SELECT snippet(p1, 0, '[', NULL, '...', 6) FROM p1('x');
```

This matches the `5.2`/`5.3`/`5.4` cases added by `fix.patch` to
`ext/fts5/test/fts5af.test`.

## What differs

- `sqlite3-clean`: exits 0, prints the three expected snippet strings
  (the NULL argument is treated as an empty string).
- `sqlite3-buggy`: crashes (SIGSEGV, exit status -11). With
  `injection.patch` applied, `fts5SnippetFunction` passes the raw
  `sqlite3_value_text()` result (which is NULL for a SQL NULL) straight
  into `fts5HighlightAppend`'s `strlen(z)`/`memcpy`-style use, dereferencing
  a NULL pointer instead of substituting `""` as the fixed code does.
