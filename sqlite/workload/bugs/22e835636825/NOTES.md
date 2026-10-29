# Notes

`repro.sql` creates an FTS5 virtual table and issues a MATCH query whose
expression is 200 levels of nested `AND (...)` parentheses, deep enough to
overflow the Lemon-generated fts5 query parser's internal stack.

- **Clean shell** (fix applied): the `%stack_overflow` handler calls
  `sqlite3Fts5ParseError(...)`, so the query fails cleanly with
  `fts5: parser stack overflow` (exit status 1).
- **Buggy shell** (`injection.patch` applied, reverting the fix): the
  `%stack_overflow` handler is `assert(0)`, so the debug build aborts via
  `assert()` (SIGABRT, exit status -6) instead of returning an error.

This corresponds to `fts5simple-19.2` in `fts5simple.test`, which
`do_catchsql_test`s this exact query and expects the clean error message.
