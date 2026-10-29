# Rationale

## src/btree.c, sqlite3BtreeInsert()
Fix hunk: added `testcase( pCur->curFlags & BTCF_ValidOvfl ); invalidateOverflowCache(pCur);`
right after clearing the old cell when overwriting (loc==0). In 3.54.1 the code
is the same apart from the BTREE_CLEAR_CELL macro; I removed those two lines,
restoring the pre-fix behaviour: the cursor's overflow-page cache stays valid
after the old cell's overflow chain is freed.

## Oracle
test/insert.test insert-15.1 fails: `accessPayload: Assertion
pCur->aOverflow[0]==nextPage || ... failed` (stale overflow cache used by
REPLACE INTO ... SELECT with large blobs). Later cases in the file do not run
because the assert aborts the process.
