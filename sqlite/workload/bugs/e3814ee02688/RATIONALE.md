# Rationale

Fix (2021-04-05): `sqlite3PagerTruncateImage()` asserted `dbSize>=nPage`, which
is false on a corrupt incremental-vacuum database whose header page count
exceeds the file size. The fix relaxed it to `|| CORRUPT_DB` (+ a testcase).

## Changes
1. `src/pager.c`, `sqlite3PagerTruncateImage`: assert is back to
   `assert( pPager->dbSize>=nPage );`. This reverses the fix hunk directly.
   The fix's added `testcase()` line is not present in 3.54.1.

2. `src/btree.c`, `lockBtree`: removed the `else{ nPage = nPageFile; }` clamp
   used when `nPage>nPageFile` and writable_schema is ON. This is the covering
   code in 3.54.1. With it, Btree's page count is clamped to the file size, so
   `pBt->nPage` can never exceed the pager's `dbSize` and the assert (even
   without `CORRUPT_DB`) cannot fire for the oracle database. Without it, the
   header count (7) is used while the file has 5 pages, the state the 2021
   code was in. It is not the same defect as hunk 1, but it is what keeps the
   pre-fix assert from firing, so it is needed to restore the failure.

## Oracle result
`incrvacuum-17.1` aborts: `sqlite3PagerTruncateImage: Assertion
'pPager->dbSize>=nPage' failed`. The test is
`PRAGMA writable_schema=ON; PRAGMA incremental_vacuum(10);` on the corrupt
database (header size 7, file 5 pages). The incomplete run also fails the
later cases in `incrvacuum.test`.
