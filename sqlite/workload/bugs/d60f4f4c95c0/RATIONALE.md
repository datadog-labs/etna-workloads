# Rationale

Bug: an invalidated incrblob cursor (eState=CURSOR_INVALID) keeps its page references, so later btree code
can wrongly report corruption ("database disk image is malformed").

## Hunks (all in src/btree.c)
1. `sqlite3BtreeInsert`: moved `invalidateIncrblobCursors()` back to *before* `saveAllCursors()`
   (reverses fix hunk 1; the call is now guarded by `pCur->pKeyInfo==0 && p->hasIncrblobCur`, as in 3.54.1).
2. `sqlite3BtreeDelete`: moved the invalidate call back before `saveAllCursors()` (fix hunk 2).
3. `sqlite3BtreeClearTable`: invalidate before `saveAllCursors()` (fix hunk 3).
4. `saveCursorsOnList`: removed the `else { btreeReleaseAllCursorPages(p); }` branch. Reordering alone no
   longer reproduces the bug because this later code (same defect, fixed a second time) releases the pages
   of non-VALID cursors. Without it, cursors invalidated before the save keep their page refs, as in the pre-fix code.

## Oracle
test/incrblob4.test cases 1.3, 2.3, 3.3 fail with "database disk image is malformed".
