# Rationale

All hunks are in `src/backend/replication/logical/worker.c`, function `apply_handle_truncate`. They reverse the single hunk set in fix_impl.patch.

- Removed `LOCKMODE lockmode = AccessExclusiveLock;` (fix hunk 1).
- `logicalrep_rel_open(relid, lockmode)` and `logicalrep_rel_close(rel, lockmode)` now use `RowExclusiveLock` (fix hunk 2).
- `find_all_inheritors(..., lockmode, ...)` now uses `RowExclusiveLock`, and `table_close(childrel, lockmode)` now uses `RowExclusiveLock` (fix hunks 3 and 4).

The apply worker again takes only RowExclusiveLock on the truncated tables. `ExecuteTruncateGuts` later needs AccessExclusiveLock, so this is a lock upgrade. With several subscriptions' apply workers truncating the same table, each can hold RowExclusiveLock while waiting to upgrade, and they deadlock.

The deadlock is timing-dependent. The first run after the build passed. Three later `--no-build` runs failed reliably.

Failing oracle case: `src/test/subscription|t/010_truncate.pl|no deadlocks detected`
