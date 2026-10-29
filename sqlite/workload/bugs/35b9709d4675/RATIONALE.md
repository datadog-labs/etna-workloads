# Rationale

## Change

File: `tree/ext/misc/zipfile.c`, function `zipfileGetEntry()`.

Reverted two of the fix's type-widening hunks that together close a 32-bit
integer-overflow path when checking whether a local file header (LFH) lies
within the in-memory zip image:

1. Bounds check before reading the LFH:
   - Fix: `if( ((i64)pNew->cds.iOffset + ZIPFILE_LFH_FIXED_SZ)>nBlob )`
   - Reverted to: `if( (pNew->cds.iOffset + ZIPFILE_LFH_FIXED_SZ)>(unsigned)nBlob )`

   `pNew->cds.iOffset` is a `u32` read from the (attacker-controlled) central
   directory record. Without the `(i64)` cast, `iOffset + ZIPFILE_LFH_FIXED_SZ`
   is computed in 32-bit arithmetic and can wrap around to a small value,
   so a corrupt/crafted offset near `0xFFFFFFFF` passes the check even
   though it is actually far outside the buffer.

2. Computation of `iDataOff` right after:
   - Fix: `pNew->iDataOff = (i64)pNew->cds.iOffset + ZIPFILE_LFH_FIXED_SZ;`
   - Reverted to: `pNew->iDataOff = pNew->cds.iOffset + ZIPFILE_LFH_FIXED_SZ;`

   Same overflow: without the cast this is 32-bit arithmetic, so
   `iDataOff` can end up wrapped/truncated and no longer equal to the
   true (64-bit) offset of the entry's data, leading to an out-of-bounds
   read via `aBlob[...]`/`fread()` later.

These are the two hunks in `fix.patch` that change the arithmetic/behavior
around the LFH offset check (as opposed to the other hunks in the same
patch, which only change parameter/local types — e.g. `int nBlob` →
`i64 nBlob`, `int nRead` → `i64 nRead` — or fix unrelated memory leaks via
`zipfileTableErr`/`sqlite3_free`). Those other hunks don't change behavior
on their own in 3.54.1 since `nBlob` is already declared `i64` there, so
leaving them as-is does not mask the bug. Reverting only the two
arithmetic hunks is the minimal change that restores the original,
recognizable overflow defect.

## Oracle result

Running `./check.sh`, all `zipfile-*` cases up through `zipfile-20.2` pass,
but execution does not reach/report a result for `zipfile-21.0` — the new
test case added by the fix, which feeds a crafted zip with
`iOffset=0xFFFFFFE2` and expects the error message
`failed to read LFH at offset -30`. With the revert in place, the 32-bit
overflow lets the bad offset pass the bounds check, and the resulting
out-of-bounds access causes the test run to fail to produce output for
that case (crash/hang) instead of reporting the expected corruption error.
This matches the bug the fix's test was written to catch.
