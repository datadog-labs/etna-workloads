repro.sql loads the corrupt fts4 database from test 52.0 (via `.open --hexdb`) and runs `SELECT * FROM t1, t2;`, where t2 is an fts4aux table over t1.

The corrupt segment contains a column number of 0 or less. The fix rejects it with SQLITE_CORRUPT_VTAB, and the injection removes the `iCol<1` check.

- Clean shell: prints some rows, then fails with a "database disk image is malformed" error. Exit status is 1.
- Buggy shell: crashes with a segfault (exit status -11), because the invalid column index is used to index `aStat`.
