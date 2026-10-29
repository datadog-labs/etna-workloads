`repro.sql` runs `CREATE TABLE t1 AS SELECT zeroblob(2e20)` inside a transaction. The SELECT fails with "string or blob too big", and the script then commits and runs `PRAGMA integrity_check`.

- clean: integrity_check prints `ok`.
- buggy: integrity_check prints `*** in database main *** Page 2: never used`. The partial sqlite_master change was not rolled back, which leaves the new root page orphaned.

This is the failure in table-18.2. table-19.1 was not reproduced separately.
