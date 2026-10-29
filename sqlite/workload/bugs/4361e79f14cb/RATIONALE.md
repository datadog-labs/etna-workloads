# Rationale

## Bug

Upstream fix `4361e79f14cb` (2009-08-14) hardened `btreeInitPage()` in
`src/btree.c` so that, while walking a page's freeblock list, it also checks
that the *last* freeblock's end (`pc+size`) does not run past `usableSize`.
Before the fix, only the "ascending order" condition (`next<=pc+size+3`) was
checked; a corrupt last freeblock whose `size` field claimed more bytes than
actually remain on the page was accepted as valid. The freeblock was later
reused by `allocateSpace()`/`pageFindSlot()` to satisfy a cell-space
allocation, which could then write past the end of the in-memory page buffer.

The fix's test (`corrupt-6.1` in `test/corrupt.test`, present in `oracle.json`)
builds a one-page table, deletes the last cell on the page to create a
freeblock right at the end of the page, then uses `hexio_write` to set that
freeblock's size field to `0x00FF` (255), which is far larger than the actual
space left on the page. It then inserts a row, which (pre-fix) can reuse the
corrupt freeblock and overwrite memory past the page buffer; post-fix it must
instead fail cleanly with "database disk image is malformed".

## Where the logic lives in 3.54.1

`btreeInitPage()` was split up over the years; the freeblock-walking logic the
fix touched is now in `btreeComputeFreeSpace()` (`src/btree.c`). It already
contained the modern form of the fix's check:

```c
if( pc+size>(unsigned int)usableSize ){
  /* Last freeblock extends past page end */
  return SQLITE_CORRUPT_PAGE(pPage);
}
```

This is exactly the check the fix hunk added (reworded/refactored but the
same condition: the final freeblock's end address exceeding `usableSize`).

## Change 1: `btreeComputeFreeSpace()` — reverts the fix's hunk directly

Removed the `if( pc+size>(unsigned int)usableSize ) return SQLITE_CORRUPT_PAGE(...)`
block after the freeblock-walking loop. This is the direct inverse of the
fix's `src/btree.c` hunk: the fix added the "last byte of the free-block
must lie on the database page" check; removing it restores the pre-fix
behaviour of accepting a freeblock list whose last entry runs off the page,
as long as the (now-removed) ascending-order/size sanity check doesn't also
happen to catch it.

## Change 2: `pageFindSlot()` — same defect covered a second, independent path

Rebuilding and running the oracle after change 1 alone still passed every
case: a *second*, newer guard in `pageFindSlot()` (the function that scans
the freelist to satisfy an allocation request, called from
`allocateSpace()`) independently re-checks the same invariant at allocation
time:

```c
}else if( x+pc > maxPC ){
  /* This slot extends off the end of the usable part of the page */
  *pRc = SQLITE_CORRUPT_PAGE(pPg);
  return 0;
}else{
```

(`maxPC = usableSize - nByte`, so `x+pc > maxPC` is algebraically the same
"freeblock end is past the usable page" test as change 1, just evaluated
while splitting a slot during allocation instead of while initializing the
page.) This is clearly later, independent hardening of the identical defect
("a freeblock claims to extend off the end of the page, and gets used
anyway"), added at some point after the original fix and effectively
re-fixing it on the allocation side. Per task rule 4, I reverted this branch
too, restoring the pre-fix code path where an oversized slot is simply
split (`put2byte(&aData[pc+2], x)`) and its base address returned, without
validating that `pc+size` stays on the page.

With only change 1, `btreeComputeFreeSpace()` accepts the corrupt page at
`sqlite3BtreeOpen`/cursor-init time, but `pageFindSlot()`'s own bounds check
still rejected the oversized slot before it could be used, so no corruption
occurred and the oracle passed. Change 2 removes that second line of
defense so the originally-vulnerable code path (page init accepts the
corrupt freeblock, then `allocateSpace` reuses it and writes past the page
buffer) is actually reachable again.

## Result

`./check.sh` now reports:

```
== test/corrupt.test: 3 of 12287 oracle cases failing: ['corrupt-6.1', 'corrupt-8.1', 'corrupt-8.2'] (incomplete run: crash, assert or timeout)
```

`corrupt-6.1` — the case the fix's test added — crashes with:

```
testfixture: sqlite3.c:74614: allocateSpace: Assertion `pSpace+nByte<=data+pPage->pBt->usableSize' failed.
```

i.e. `allocateSpace()` is handed a pointer that already runs past the end of
the page buffer, which is precisely the "write past the end of a buffer as a
result of a corrupted database file" defect the fix describes (the debug
build's assert catches it deterministically; a non-assert/release build
would perform the out-of-bounds write the assert is guarding against).
`corrupt-8.1`/`corrupt-8.2` subsequently fail only because the test run
aborts after the `corrupt-6.1` crash and never executes.

No files outside `tree/src/btree.c` were changed; no tests, build files, or
other implementation files were touched.
