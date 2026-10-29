repro.sql loads the corrupt database from corruptL-10.0 (`.open --hexdb`), turns off
defensive mode and sets writable_schema=ON (the shell, unlike the test harness, has
extra schema checks on, which reject this corrupt schema before the query runs), then runs
`SELECT * FROM t1 WHERE a<='2019-05-09' ORDER BY a DESC;`.

Clean: `Error near line 134: database disk image is malformed`, exit 1.
Buggy: the shell crashes (SIGSEGV, status -11) because the error returned by
sqlite3BtreeLast() in OP_SeekLE is ignored in the buggy build.
