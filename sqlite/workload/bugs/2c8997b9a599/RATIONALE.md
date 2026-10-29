# Rationale

Fix (ticket #1375): with PRAGMA synchronous=OFF on all databases, a multi-file
commit must not sync the master journal (fix hunks in vdbeaux.c `needSync`,
pager.c `needSync = !noSync`, plus the `SyncDisabled` accessors).

In 3.54.1 this is handled differently: `vdbeCommit()` in src/vdbeaux.c only
counts a database toward `nTrans` (which selects the super-journal path) if
`db->aDb[i].safety_level!=PAGER_SYNCHRONOUS_OFF`. When every database has sync
off, no super-journal is created and thus none is synced. This is the modern
equivalent of the fix's `needSync` logic in vdbeCommit.

## Change
src/vdbeaux.c, `vdbeCommit()`: removed the `safety_level!=PAGER_SYNCHRONOUS_OFF`
test from the `nTrans++` condition. The super-journal is again created and
synced for multi-database commits even with synchronous=OFF, as before the fix
(the old unconditional `sqlite3OsSync(&master)`).

## Oracle
test/sync.test sync-1.4 fails (expected 0 syncs, got 3). sync-1.1..1.3 still pass.
