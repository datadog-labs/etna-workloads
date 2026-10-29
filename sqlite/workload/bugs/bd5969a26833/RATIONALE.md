# Rationale

Fix hunk: `moveToChild()` returned SQLITE_CORRUPT when `pNewPage->intKey != parent->intKey`
(in addition to `nCell<1`). In 3.54.1 that check is `pPage->intKey!=pCur->curIntKey`.

Changes (both in src/btree.c, both drop the `intKey!=curIntKey` term, leaving `nCell<1`):
1. `moveToChild()` – direct counterpart of the fix hunk.
2. `sqlite3BtreeIndexMoveto()` – contains a hand-inlined copy of `moveToChild()`
   (marked "in-lined moveToChild() call") with the same check. Reverting only (1) left
   the bug covered, since the DELETE in the oracle reaches the corrupt child via this
   index-seek path. It is the same defect, so it is reverted too.

Oracle: corrupt-4.2 fails. A corrupt index root cell points to a table (intKey) page;
instead of returning "database disk image is malformed", it hits
`Assertion pPage->intKey==0 failed` in sqlite3BtreeIndexMoveto, aborting the run.
