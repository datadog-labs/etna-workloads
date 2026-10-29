sqlite3_blob_open() has no SQL-level entry point, but R-Tree opens its `%_node` table through it. The reproducer creates an R-Tree and inserts one row.

- clean: the insert works and `SELECT` returns `1|1.0|2.0` (exit 0).
- buggy: both statements fail with "database disk image is malformed" (exit 1).

The injection removes `aOp[3].p2 = pTab->nCol`, so the blob-open program reads column 0 instead of the imaginary extra column. That is wrong: it reads real data, which the extra column was meant to avoid.

This reproducer shows a different symptom from the upstream test, which checks memory use (incrblob2-7.x). I did not find an SQL way to show the large allocation.
