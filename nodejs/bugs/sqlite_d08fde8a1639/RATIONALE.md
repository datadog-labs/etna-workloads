# Re-introduced bug: tag store iterators not invalidated on statement reset (CVE-2026-58041)

**Bug.** SQLTagStore methods reset the shared cached statement without going through `Statement::ResetStatement()`, so `reset_generation_` was never bumped and live iterators on the same cached statement stayed valid. They could keep stepping a statement that had been re-bound/re-run (e.g. replaying a victim's bound write). Also, an iterator that hit SQLITE_DONE was not marked `done_`, so a further `next()` could restart the statement.

**Hunks** (in `src/node_sqlite.cc`; in this release the four Run/Iterate/Get/All reset calls were refactored into the shared `SQLTagStore::ResetAndBindStatement`):
1. `ResetAndBindStatement`: `stmt->ResetStatement()` -> `sqlite3_reset(stmt->statement_.get())`. Corresponds to the four hunks in Run/Iterate/Get/All; skips the generation bump, restoring the old behaviour.
2. `StatementIterator::Next`: removed `iter->done_ = true;` in the SQLITE_DONE branch. Corresponds to the `iter->done_ = true` hunk of the fix.

**Failing tests.** `parallel/test-sqlite-template-tag` reports `not ok` (stable over repeated runs). The first failing subtests are the new ones, and the later subtests then fail in the `beforeEach` with `database table is locked` (ERR_SQLITE_ERROR, errcode 6). Stale iterators are no longer invalidated and keep the table locked. I only inspected the tail of the TAP output and did not view the exact assertion output of the invalidation subtests.
