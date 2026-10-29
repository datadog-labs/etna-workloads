Reproducer for nockpt-1.15: switch a WAL database to rollback mode with
SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE set (`.dbconfig no_ckpt_on_close on`).

The clean shell checkpoints and deletes the -wal file when leaving WAL mode,
so `ls test.db*` shows only test.db. The buggy shell skips the checkpoint,
so test.db-wal and test.db-shm are left behind.

repro.sql creates test.db in the current directory, so run it in an empty directory.
