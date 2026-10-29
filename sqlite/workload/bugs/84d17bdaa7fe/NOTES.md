repro.sql loads the corrupt FTS5 database from test 68.0 of fts5corrupt3.test (via `.open --hexdb`), then runs the 68.1 statements (`INSERT INTO t1(t1) SELECT x FROM t2` with reverse_unordered_selects=ON).

- clean: `Error near line 211: fts5: corruption on page 1, segment 1, table "t1"`, exit 1.
- buggy: aborts with `Assertion 'n>0' failed` in fts5TestUtf8 (assert instead of assert_nc), exit -6.
