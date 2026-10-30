Reproducer: single server, AOF on with `appendfsync everysec`. Start an AOF rewrite with a slow child
(`rdb-key-save-delay`), and while it runs issue `INCR foo` + `WAITAOF 1 0 2500` on one connection.

Clean: `WAITAOF` returns `1 0` (local AOF fsynced) once the rewrite finishes.
Buggy: the rewrite-done handler wrongly marks the INCR file as fsynced (aof_last_incr_fsync_offset,
aof_last_fsync) and the "all data fsynced, update fsynced_reploff_pending" fallback is gone, so
the write is never fsynced/acked and `WAITAOF` times out with `0 0`.
This is the root cause of the WAITAOF hangs in tests/unit/wait.tcl (everysec->always with AOFRW onward).
