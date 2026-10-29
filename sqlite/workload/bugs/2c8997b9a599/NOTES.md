Reproducer: `repro.sh` (sync-1.4 counts fsyncs via the harness's sqlite_sync_count, which the shell lacks, so it builds a tiny LD_PRELOAD shim that counts fsync/fdatasync and prints `syncs=N` to stderr at exit).

It creates a main db and an attached db, sets `synchronous=off` on both, and does a multi-database transaction commit (which writes a master journal).

Clean shell: `syncs=0`. Buggy shell: `syncs=3`, because the master-journal commit path no longer checks the safety level, so it still syncs.
