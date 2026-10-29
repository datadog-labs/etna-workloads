# Rationale

The fix (5d0455fe, fixing a regression from [4cd2a967]) hardens
`defragmentPage()` in src/btree.c against a corrupt page where two
freeblocks recorded in the page header overlap. Before the fix, the
two-freeblock fast path computed

    memmove(&data[iFree+sz+sz2], &data[iFree+sz], iFree2-(iFree+sz));

without checking that `iFree2 >= iFree+sz`. If the freeblocks overlap
(`iFree+sz > iFree2`), `iFree2-(iFree+sz)` is negative; cast to `size_t`
for `memmove`'s length argument this becomes a huge value, producing a
large out-of-bounds write. The fix adds an explicit guard,
`if( iFree+sz>iFree2 ) return SQLITE_CORRUPT_BKPT;`, before the `memmove`.

## Changes made

### 1. src/btree.c — `defragmentPage()`

Removed the guard (3.54.1's spelling of the same check):

```c
if( iFree2 ){
  sz2 = get2byte(&data[iFree2+2]);
  if( iFree2+sz2 > usableSize ) return SQLITE_CORRUPT_PAGE(pPage);
- if( iFree+sz>iFree2 ) return SQLITE_CORRUPT_PAGE(pPage);
  memmove(&data[iFree+sz+sz2], &data[iFree+sz], iFree2-(iFree+sz));
  sz += sz2;
}
```

This directly reverses the fix's core hunk: `if( iFree+sz>iFree2 ) return
SQLITE_CORRUPT_BKPT;` (the fix used the then-current `SQLITE_CORRUPT_BKPT`
macro; 3.54.1 renamed the equivalent page-level macro to
`SQLITE_CORRUPT_PAGE(pPage)`, already used by the surrounding code, so no
other change was needed to restore the exact removed check).

### 2. src/btree.c — `btreeComputeFreeSpace()`

In 3.54.1, free-space accounting was reorganized (lazily computed in
`btreeComputeFreeSpace()` rather than inline in `decodeFlags`/`btreeInitPage`
as in 2017). That function independently validates the freeblock chain
while summing free bytes, and its ordering check already happened to
reject the overlapping-freeblock corruption this bug needs, via:

```c
if( next<pc+size+4 ) break;
```

(loop stops once the next freeblock does not start at least 4 bytes past
the end of the current one, i.e. `next < pc+size+4` — this incidentally also
rejects overlap, since overlap implies `next < pc+size`). After the loop,
`if( next>0 ) return SQLITE_CORRUPT_PAGE(pPage);` — "Freeblock not in
ascending order" — fires whenever the loop stopped early, so this path
already caught the corruption that change 1 alone is meant to let through,
and removing only change 1 left all oracle cases passing.

This is the same defect reached by a second path: 3.54.1's freeblock-chain
validator enforces a stronger invariant (a minimum gap between freeblocks)
than the 2017 code did, which happens to also block the overlap this bug
needs to reach `defragmentPage()`. The fix's comment explicitly describes
the pre-fix assumption: "pageFindSlot() has already verified that free
blocks are sorted in order of offset within the page, and that no block
extends past the end of the page" — i.e. only ordering and extent were
checked, not the stronger minimum-gap/no-overlap property added later in
3.54.1's rewrite of the free-space scan. Restoring the original behaviour
means loosening this check back to ordering-only:

```c
-      if( next<pc+size+4 ) break;
+      if( next<=pc ) break;
```

This keeps "freeblocks must be in strictly ascending order of offset"
(matching `pageFindSlot()`'s own order check, left untouched) while
dropping the no-overlap / minimum-gap requirement, which is exactly the
gap the fix's new check in `defragmentPage()` exists to close.

Both changes trace to the same defect (a corrupt page with two overlapping
freeblocks reaching the unchecked `memmove()` in `defragmentPage()`); the
second is a duplicate/overlapping guard introduced by 3.54.1's later
freelist-validation rewrite, revived per task step 4.

## Oracle results

With both changes applied, `./check.sh` reports:

```
== test/corruptK.test: 4 of 9 oracle cases failing: ['corruptK-2.3', 'corruptK-3.1', 'corruptK-3.2', 'corruptK-3.3']
corruptK-2.3...testfixture: sqlite3.c:NNNN: defragmentPage: Assertion `cbrk+(iFree-top) <= usableSize' failed.
```

`corruptK-2.3` sets up two overlapping freeblocks via `sqlite3_blob_write()`
exactly as the fix's test does, then issues an `INSERT` that reaches
`defragmentPage()`'s two-freeblock fast path. With the guard removed,
`iFree2-(iFree+sz)` underflows and the subsequent `memmove()` writes out of
bounds; in this debug build that is caught by the page-content invariant
assert a few lines later (`cbrk+(iFree-top) <= usableSize`), which aborts
the process — in a release build it would be the raw buffer overwrite the
fix describes. This aborts the test run, so cases 3.1–3.3 (which run after
2.3 in the same file) never execute and are reported as failing/incomplete
too. This is the crash/abort failure mode the task calls for: at least one
oracle case fails, and it is the same mechanism (corrupt overlapping
freeblocks reaching the unguarded `memmove` in `defragmentPage()`) that the
fix's test was written to catch.

Test case 1.4, which the fix's test file uses for the single-freeblock
variant of this bug, is disabled upstream in 3.54.1's `corruptK.test`
("This test no longer functions due to the deferred computation of
MemPage.nFree") and is correctly absent from `oracle.json`.
