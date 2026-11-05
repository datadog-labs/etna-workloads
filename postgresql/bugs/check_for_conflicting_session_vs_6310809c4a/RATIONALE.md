# Rationale

File: src/backend/storage/lmgr/lock.c

- `CheckForSessionAndXactLocks()` removed, and its call in `AtPrepare_Locks()` removed (fix.patch hunks 1 and 2). Without it, the session-vs-xact conflict is no longer checked per LOCKTAG across all lock modes.
- `AtPrepare_Locks()`: the per-locallock `haveSessionLock` error is kept as the only check (fix.patch hunk 3 reversed). It only sees one lockmode per LOCALLOCK entry, so a session lock in one mode plus an xact lock in another mode on the same object slips through and PREPARE succeeds wrongly.

Failing oracle case: src/test/regress||prepared_xacts
