`repro.sql` loads the corrupt database from fts3corrupt4-49.0 (via `.open --hexdb`), then runs the 49.1 statements: a savepoint, a DELETE with `MATCH 'c*'`, and a `matchinfo()` query with `MATCH 'f*e*'`.

- Clean shell: the statements run, and the SELECT prints `0`.
- Buggy shell: it aborts with `Assertion 'rc!=0' failed` in `fts3SegReaderCmp` (exit status -6). The injection turns `assert_fts3_nc` back into a plain `assert`, and corrupt segments can make that comparison return 0.
