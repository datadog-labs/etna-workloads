# Rationale

Fix hunk reversed: `sqlite3WalClose()` in src/wal.c called `sqlite3WalCheckpoint()`
(which refreshes the connection's private wal-index header) instead of the
internal `walCheckpoint()` (which uses `pWal->hdr` as is). The fix made close go
through the public routine so a stale header is not checkpointed.

In version-3.54.1 `sqlite3WalCheckpoint()` still does that refresh
(`walIndexReadHdr`), so close now calls `walCheckpoint()` directly, as before
the fix. Because modern `walCheckpoint()` asserts that the ckpt lock flag is
set and that it runs inside an SEH try block, the call is wrapped in
`SEH_TRY/SEH_EXCEPT` and `pWal->ckptLock` is set/cleared around it (the real
locks are unneeded: the db is EXCLUSIVE-locked and in exclusive mode). The last
connection to close therefore checkpoints its possibly out-of-date header,
so newer transactions are lost/discarded (wal-19.4 scenario).

The fix's manifest/wal.test hunks and the unused `walMappingSize` helper are not
relevant to the behaviour.

## Oracle result
`./check.sh`: 240 of 561 wal.test oracle cases fail; the run does not complete
(hang/timeout in wal-18.2.5.*, after which all later cases, including wal-19.*,
are not reached). The failure mode is a stale-snapshot checkpoint at close, not
a clean wal-19.4 mismatch.
