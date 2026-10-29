repro.sql: REPLACE INTO t1 SELECT ... with three rows of the same rowid and 31k/32k/33k-byte blobs, so the
overflow cell is overwritten repeatedly (table t1 also has an index on b).
Clean: prints `4|33000`. Buggy (stale btree cursor overflow cache not invalidated in
sqlite3BtreeInsert): "Error near line 8: database disk image is malformed", exit status 1.
