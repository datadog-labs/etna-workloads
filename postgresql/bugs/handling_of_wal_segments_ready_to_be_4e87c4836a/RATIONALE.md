# Rationale

Changed: `src/backend/access/transam/xlogarchive.c`, `XLogArchiveCheckDone()`.

Traces to the `xlogarchive.c` hunk of fix.patch. The fix replaced the `RecoveryInProgress()`-based check with `XLogArchivingActive()` plus `GetRecoveryState() == RECOVERY_STATE_ARCHIVE`. I restored the pre-fix logic, so the function calls `RecoveryInProgress()` and treats the server as a standby whenever it is in recovery.

This brings the bug back because crash recovery on a primary also counts as "in recovery". With archive_mode=on, `XLogArchivingActive() && !inRecovery` is false, so the function returns true. Segments still waiting to be archived then have their `.ready` files removed or recycled during crash recovery.

The `RecoveryState` enum, `GetRecoveryState()` and the xlog.c bookkeeping are left in place. They are now unused, and the bug does not depend on them.

Failing oracle cases: 16 of 19. The key one is ".ready file for WAL segment <N> still exists after crash recovery on primary". The other 15 report 'missing' (the oracle found no result for them) rather than a direct failure, probably because the TAP script stops after that failure. Only these 3 still pass:
- ".done file does not exist for WAL segment <N> waiting to be archived"
- ".ready file exists for WAL segment <N> waiting to be archived"
- "pg_stat_archiver failed to archive <N>"
