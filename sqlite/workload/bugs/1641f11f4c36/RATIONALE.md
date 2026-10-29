# Rationale

## Hunk changed: src/btree.c, sqlite3BtreeDelete()
Reverses the fix's only implementation hunk, which added `|| pPage->nCell==1`
to the condition that decides whether a rebalance is required (and so whether
the cursor key must be saved) when BTREE_SAVEPOSITION is set. The line still
existed verbatim in 3.54.1 (with `xCellSize` in place of `cellSizePtr`), so
removing it restores the pre-fix condition. On a corrupt page whose nFree is
under-reported, deleting the last cell is again treated as needing no
rebalance, leaving a page with zero cells.

(The Makefile/manifest/test hunks in the fix are not implementation changes.)

## Oracle results
test/dbfuzz001.test: dbfuzz001-100 and -101a still pass. dbfuzz001-110, the
DELETE of the last cell on page 8, crashes or asserts, so 110 and every later
case are never run (8 of 10 oracle cases fail).
