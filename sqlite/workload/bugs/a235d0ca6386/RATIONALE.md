# Rationale

Fix: fts3 tables could not be renamed mid-transaction (pending terms were never flushed before the rename; the statement was not un-expired after xRename).

## Changes
1. `src/vdbe.c` OP_VRename: removed `p->expired = 0;` (reverses the fix's vdbe.c hunk).
2. `ext/fts3/fts3.c` fts3RenameMethod: removed the `sqlite3Fts3PendingTermsFlush()` call (and its `assert(nPendingData==0)`), reversing the fix's flush hunk. `rc` is still initialised via `fts3SetHasStat()`.
3. `ext/fts3/fts3.c` fts3SavepointMethod: disabled the `'flush'` of pending terms (`if( 0 && ...)`). Today this path also covers the case: ALTER TABLE RENAME opens a savepoint, whose xSavepoint flushes pending terms before xRename, so hunk 2 alone is a no-op (the original comment in fts3RenameMethod says so). Reverting it restores the pre-fix state where nothing flushes pending data before rename (xSavepoint did not exist in 2010).

## Oracle failures
Hunk 1 alone: no failures. With all three: fts3ao-4.5 (COMMIT -> "SQL logic error"), and 4.6, 4.7, 4.8 ("no such table: t5") fail — the pending rows inserted before the rename in the transaction are flushed against the renamed shadow tables, breaking the commit.
