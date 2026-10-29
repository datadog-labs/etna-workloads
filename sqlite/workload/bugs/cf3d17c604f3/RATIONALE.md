# Rationale

Fix: `freeSpace()` assert `iStart>=hdrOffset+6+childPtrSize` was relaxed to `CORRUPT_DB || ...`
because a corrupt page can make a cell pointer point into the page header / cell-pointer array.

Changes in `tree/src/btree.c`:

1. `freeSpace()`: restored the pre-fix assert without `CORRUPT_DB ||` (the fix's only implementation hunk).
2. `sqlite3BtreeDelete()`: removed the later check `if( pCell<&pPage->aCellIdx[pPage->nCell] ) return SQLITE_CORRUPT_PAGE`.
   Reverting hunk 1 alone does not reproduce the bug in 3.54.1, because this check rejects the
   same case (cell pointer below the cell-content area) before `dropCell()`/`freeSpace()` is reached.
   It is the same defect covered by a second path.

Oracle: corruptI-4.1 (the test added by the fix) now aborts with
`freeSpace: Assertion 'iStart>=pPage->hdrOffset+6+pPage->childPtrSize' failed`; the run aborts, so
later cases 5.0-8.2 also fail as incomplete.
