Reproducer (repro.sh): two long-lived shell connections on a WAL db, both with
.timeout 1000 (blocking locks). After the second one has read the db, the first
16 bytes of test.db-shm are overwritten with garbage, then the second connection
runs PRAGMA wal_checkpoint=TRUNCATE, which forces wal-index recovery.

Clean: checkpoint succeeds (0|0|0). Buggy: the checkpoint no longer disables
blocking locks around walIndexReadHdr(), so recovery runs with blocking locks and
the shell aborts: unixShmLock Assertion `flags!=(SQLITE_SHM_EXCLUSIVE|SQLITE_SHM_LOCK) || 0==(p->exclMask & mask)' failed.
