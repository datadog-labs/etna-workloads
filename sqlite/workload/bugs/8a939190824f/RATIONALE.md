# Rationale

Fix (ticket #3811) hunk reversed: `sqlite3PagerJournalMode()` in pager.c gained
`&& !pPager->dbModified`, so the journal mode can only change when no
transaction is pending. Before the fix the mode could change at any time, even
mid-transaction, and `PRAGMA journal_mode` then reported the new mode.

In 3.54.1 that check lives in `OP_JournalMode` (src/vdbe.c), as
`if( !sqlite3PagerOkToChangeJournalMode(pPager) ) eNew = eOld;`, which forces
the mode back to the old one when the pager is in a write transaction. I removed
that line, so the mode change goes through during a transaction as it did before
the fix. The `OkToChangeJournalMode` function (the modern `!dbModified` test)
is left defined but is no longer called.

The other hunks (VerifyCookie under init.busy, prepare.c SQLITE_EMPTY handling)
are unrelated to the journal mode behaviour tested and were not touched.

## Oracle failures
jrnlmode3-3.N.3 (and many others in jrnlmode3-3.*): `PRAGMA journal_mode=X`
inside a transaction returns X instead of the old mode. The run then trips an
assert in `assert_pager_state` (journal not open under a non-OFF mode).
jrnlmode-6.1/6.2/6.3 also fail (wrong mode reported, journal file missing, assert).
