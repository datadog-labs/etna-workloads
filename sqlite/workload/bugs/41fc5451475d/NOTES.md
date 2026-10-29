Reproducer for fts3corrupt4-19.1: `repro.sql` loads the corrupt FTS3 database from the test with `.open --hexdb`, then runs `snippet()` on it.

The one change from the test's database is the `tbl_name` of the `t1` schema row, from `tA` to `t1`. The test turns off `extra_schema_checks`, and the shell has no way to do that, so the schema would otherwise fail to load.

- **Clean shell:** prints a partial row, then `Error near line 214: database disk image is malformed`, exit status 1.
- **Buggy shell:** aborts with `Assertion 'iFirst>=0' failed` in `fts3SnippetFindPositions`, exit status 134 (SIGABRT).
