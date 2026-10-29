Reproducer for fts3corrupt4-21.1: `repro.sql` loads the corrupt FTS3 database from test 21.0 with `.open --hexdb`. It then turns off defensive mode and sets `writable_schema=1`, and runs `SELECT offsets(t1) FROM t1 WHERE t1 MATCH 'R*'`.

- clean: `Error near line 210: database disk image is malformed`, exit status 1.
- buggy: assertion failure `fts3ExprTermOffsetInit: Assertion 'iPos>=0' failed`, abort (exit status -6).

The injection turns `assert_fts3_nc` back into a plain `assert` in fts3_snippet.c. Corrupt position lists can make that assertion false.
