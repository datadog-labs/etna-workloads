# Rationale

Only `src/main.c`, `sqlite3RollbackAll()` changed: removed the `sqlite3BtreeEnterAll(db)` / `sqlite3BtreeLeaveAll(db)` pair that surrounded the per-btree rollback and schema reset.

- Reverses fix hunk 2 and 3 (the added `sqlite3BtreeEnterAll`/`LeaveAll` in `sqlite3RollbackAll`). Without the b-tree mutexes, another shared-cache connection can slip in between the btree rollback and the schema reset.
- Fix hunk 1 (`sqlite3VtabRollback` -> `sqlite3RollbackAll` in `sqlite3Close`) needed no change: 3.54.1 already has `sqlite3VtabRollback` there, and close reaches `sqlite3RollbackAll` via `sqlite3LeaveMutexAndCloseZombie`. So the close path hits the unprotected rollback.

Failing oracle case: `sharedA-2.4`. The thread's step of the stale statement gets `SQLITE_CORRUPT` ("malformed database schema (i1) - index i1 already exists") instead of `SQLITE_SCHEMA`, the false corruption report the mutex comment describes.
