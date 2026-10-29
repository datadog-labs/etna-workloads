# Rationale

The fix (CVS 5689) made b-tree traversal reject loops in corrupt files, where a
page is its own ancestor. It added a `pPage==pParent` check in
`sqlite3BtreeInitPage`, a parent-mismatch check in `getAndInitPage`, and passed
the correct parent in `clearDatabasePage`. Version 3.54.1 has no parent
pointers, so those hunks can't be reversed literally. Loop protection now comes
from a depth bound and a refcount check, and I removed both (both in `src/btree.c`).

- `moveToChild`: removed the `iPage>=BTCURSOR_MAX_DEPTH-1` check that returns
  SQLITE_CORRUPT. It replaces the `getAndInitPage` loop checks from the fix. Without
  it, a cursor follows a looping tree downward until it overruns `apPage[]`.
- `clearDatabasePage`: removed the `sqlite3PagerPageRefcount` check. It flags a
  page reached again while still held as an ancestor, which matches the fix's
  corrected parent argument in the same function. The depth check in that
  function is still there.

## Oracle results

`./check.sh` runs `test/corruptB.test`. Cases 1.1 to 1.3.1 pass. Case 1.3.2
(`SELECT * FROM t1` on a root page whose right child is itself) hits the assertion
`moveToChild: pCur->iPage<BTCURSOR_MAX_DEPTH` and the run aborts, so the later cases
(1.4.x to 3.1.x) don't complete. The test expects `database disk image is malformed`.
In a build without asserts the same input would overrun the cursor page stack.
