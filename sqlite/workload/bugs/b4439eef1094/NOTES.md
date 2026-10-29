# Reproducer notes

`repro.sh` rebuilds the corrupt FTS3 database used by the upstream test
`test/fts3corrupt4.test` test case 7.1 (added by `fix.patch`). It embeds the
test's `decode_hexdb`-format byte dump (same `crash-04bb6e7c811ce9.db`
corpus) and reconstructs it with a small inline Python script that mimics
`test_decode_hexdb` in `src/test1.c`, since the CLI shell has no built-in
equivalent of `db deserialize [decode_hexdb ...]`. It then runs:

```sql
SELECT matchinfo(t1,'y') FROM t1 WHERE t1 MATCH 'e*';
```

against the rebuilt `test.db` with the given `$SQLITE3` shell.

The database's `t1_segments` doclist contains a phrase entry whose column
number is greater than or equal to the number of columns in the `t1` fts3
table. `fts3ExprLHits()` (`ext/fts3/fts3_snippet.c`), used while computing
the `'y'`/`'b'` matchinfo directives, does not check this column number
against `nCol` before using it to index into/write the per-column hit array.

- **Clean (`sqlite3-clean`)**: detects the out-of-range column number and
  fails with `SQLITE_CORRUPT_VTAB`, printing `Error in 2nd command line
  argument: database disk image is malformed` and exiting with status 1.
- **Buggy (`sqlite3-buggy`, `injection.patch` applied)**: the bounds check is
  missing, so the out-of-range column number is used unchecked. The query
  succeeds (exit status 0) and returns a `matchinfo()` blob with extra/wrong
  values (memory beyond the intended output array is written and read), i.e.
  a wrong result instead of a corruption error.
