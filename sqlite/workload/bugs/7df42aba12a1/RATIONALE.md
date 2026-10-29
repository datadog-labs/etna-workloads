# Rationale

Two changes to `tree/src/btree.c`.

## 1. `moveToRoot`: corrupt-root check only on a fresh load
Reverses the fix's `moveToRoot` hunk. Before the fix, the
`(pKeyInfo==0)!=intKey` check ran only when the root page was being loaded
(`iPage<0`). The fix moved it so it also covers a root that is already loaded.
Version 3.54.1 has that fixed form, and the `iPage>0` path jumps to `skip_init`
past it. I moved the check back inside the `getAndInitPage` branch and dropped
the `isInit==0` test, which the fix added in the same place. A cursor that
resets to an already-loaded root, whose page was meanwhile linked into another
b-tree or the freelist, is no longer re-validated.

## 2. `btreeGetUnusedPage`: missing `*ppPage = 0`
Reverses the fix's `*ppPage = 0;` hunk. That code was in `allocateBtreePage`
then and now lives in `btreeGetUnusedPage`. I removed the line, so after
releasing the page and returning SQLITE_CORRUPT the caller's pointer dangles.

## Not reverted
The `assertCellInfo` hunk (`CORRUPT_DB ||`) has no equivalent: the assert is now
`cellInfoEqual`, and it already has `CORRUPT_DB ||`. It only relaxes an assert.
Newer refcount checks in `clearDatabasePage` and `clearCellOverflow` also catch
cases 1.3 and 3.3. I left those alone.

## Oracle results (`./check.sh`)
`corruptH-2.3` fails. The INSERT inside the SELECT hits the freelist page that
is also t1's root. `btreeGetUnusedPage` returns corrupt with a dangling
`*ppPage`, and the process aborts on
`sqlite3PagerGetData: Assertion pPg->nRef>0`. The run then stops, so
`corruptH-3.1`, `3.2` and `3.3` are reported as failing too, because they never
ran.
