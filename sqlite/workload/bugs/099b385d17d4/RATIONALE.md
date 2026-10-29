# Rationale

The fix introduced SQLITE_MAX_DB (=SQLITE_MAX_ATTACHED+2) as the "all schemas" sentinel for
checkpointing. Before it, SQLITE_MAX_ATTACHED was used, which collides with a real aDb[] index
(the last attached db, index SQLITE_MAX_ATTACHED). The macro SQLITE_MAX_DB is kept in sqliteInt.h
(unused by the changed code now, still used by nothing else), and the uses are reverted:

- src/main.c sqlite3_wal_checkpoint_v2: `iDb = SQLITE_MAX_ATTACHED` for "no zDb" (reverses main.c hunk 1/2; the testcase line was left).
- src/main.c sqlite3Checkpoint: `iDb==SQLITE_MAX_ATTACHED` test for "all" (reverses the last main.c hunk).
- src/pragma.c PRAGMA wal_checkpoint: `iBt = pId2->z ? iDb : SQLITE_MAX_ATTACHED` (reverses pragma.c hunk).
- src/build.c, src/expr.c asserts restored to the old bounds (SQLITE_MAX_ATTACHED+2 / SQLITE_MAX_ATTACHED), reversing those hunks.

Effect: `PRAGMA aN.wal_checkpoint` on the last attached database (index SQLITE_MAX_ATTACHED)
is treated as "checkpoint all schemas".

Oracle failure: test/wal.test wal-26.2.8 fails (checkpointing the last attached db also
checkpointed the others, so their WALs were truncated). attach-13.1 needs asserts enabled to trigger.
