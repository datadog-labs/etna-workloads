`repro.sql` loads the corrupt FTS4 database from fts3corrupt4 test 14.0 with `.open --hexdb`, inserts ten 3000-byte blobs (test 14.1), then runs `INSERT INTO t1(t1) VALUES('optimize')` (test 14.2).

- clean: `Error near line 194: database disk image is malformed`, exit status 1.
- buggy: the missing `nSuffix<=0` check in `fts3SegWriterAdd` trips `Assertion 'nSuffix>0' failed`, and the shell aborts (status -6).

One byte of the hexdb is changed from the test's: the tbl_name of the `t1_segdir` schema row, `t1_segdi%`, is now `t1_segdir`. The test harness turns off extra schema checks (`extra_schema_checks 0`), but the shell's `.testctrl` doesn't support that option. Without the edit the schema fails to load before the bug is reached.
