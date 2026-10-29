# Rationale

The fix (2012-01-12) removed `assert()`s in `btree.c` that fail on corrupt
databases where one page is linked into two b-trees. Reintroducing the bug
means putting those asserts back and letting the corrupt state reach them.
All changes are in `src/btree.c`.

1. `moveToParent` -> `assertParentIndex`. The fix disabled the
   `assertParentIndex(...)` call. In 3.54.1 that call is still present, but the
   helper starts with `if( CORRUPT_DB ) return;`. I removed that early return so
   the parent-index asserts are live again on corrupt databases.

2. `btreeNext`. The fix replaced `assert( idx<=pPage->nCell )` with a testcase.
   I restored `assert( idx<=pPage->nCell );` after `idx = ++pCur->ix` (after the
   isInit check).

3. `balance()` / `anotherValidCursor()`. This is a later fix covering the same
   scenario: it returns SQLITE_CORRUPT instead of calling `balance_deeper` when
   another cursor is valid on the page. It makes corruptF fail with
   "malformed" before the asserts can be reached. It is the same defect
   (a page shared by two b-trees changes under a live cursor), so I reverted
   it by removing the function and the `&& anotherValidCursor()` condition.

## Oracle result
`corruptF-1.7.1` aborts with `btreeNext: Assertion 'idx<=pPage->nCell' failed`.
The run stops there, so the remaining 1.7.x and 2.x cases are not run and
count as failing (261 of 268). This is the assert the fix's test guards against.
