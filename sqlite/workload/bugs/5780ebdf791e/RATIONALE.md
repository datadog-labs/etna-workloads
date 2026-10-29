# Rationale

Fix (CVS 5881): `checkTreePage()` used the page header's cell-content offset
(`get2byte(&data[hdr+5])`) unchecked as a memset length into a `usableSize`
buffer, so an offset > usableSize overflowed. The fix added a range check.

In 3.54.1 that code no longer exists. The offset is validated earlier, in
`btreeComputeFreeSpace()` (src/btree.c): `if( nFree>usableSize || nFree<iCellFirst )`.
Its comment says the check "also serves to verify that the offset to the start
of the cell-content area ... lies within the page". `checkTreePage()` now
relies on that and has `assert( contentOffset<=usableSize )`.

## Change
src/btree.c, `btreeComputeFreeSpace()`: dropped the `nFree>usableSize` term,
leaving `if( nFree<iCellFirst )`. This reverses the fix's "content offset >
usableSize is corruption" check. It's the same defect: a corrupt content offset
is no longer rejected and reaches `checkTreePage()`.

Side effect: the same term also bounded the freeblock-size sum, so that is no
longer checked either.

## Oracle
`corruptC-2.1` (hexio_write 04 at byte 2053, then `PRAGMA integrity_check`)
now crashes: `checkTreePage: Assertion 'contentOffset<=usableSize' failed`.
That aborts the run, so about 99674 of 99676 cases fail (the first two pass).
Baseline: 0 failing.
