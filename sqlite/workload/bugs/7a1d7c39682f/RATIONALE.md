# Rationale

## src/pager.c, sqlite3PagerCommitPhaseTwo()
Reverses the fix's two pager.c hunks: the `pPager->iDataVersion++` right after
the `errCode` check is removed, and restored just before
`pager_end_transaction()` (after the PERSIST/exclusive no-op early return).
This is exactly the pre-fix placement; the code around it is unchanged apart
from the `setSuper` rename.

Effect: an empty write transaction with locking_mode=EXCLUSIVE and
journal_mode=PERSIST takes the early-return path without incrementing
iDataVersion, but sqlite3BtreeCommitPhaseTwo still does
`iBDataVersion--` to compensate. So `PRAGMA data_version` goes down (wraps
to 0 here).

## Oracle failures
`test/pragma3.test` pragma3-520B: expected 1, got 0.
(The fts5integrity cases are in the oracle but pass.)
