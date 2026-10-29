# Rationale

Bug: WAL offsets were computed in 32-bit arithmetic, so databases/WALs larger than 2^32 bytes were written to the wrong offsets.

## Changes (tree/src/wal.c)

1. `walFrameOffset` macro: removed the `(i64)` cast on `((szPage)+WAL_FRAME_HDRSIZE)`. Reverses the fix's macro hunk. `iFrame` is u32 and `szPage` is int, so the product is computed in 32 bits and overflows.
2. `walCheckpoint`: the db-file write offset is `(iDbpage-1)*szPage` again, without the `(i64)` cast. This reverses the fix's `i64 iOffset = (i64)(iDbpage-1)*szPage` hunk. Today's code has the same logic as `iOffset = (iDbpage-1)*(i64)szPage`. `iDbpage` is u32 and `szPage` is int, so the product overflows past 4GiB.

The fix's other hunks do not need reverting. The error-handling restructure in the checkpoint loop is behaviour-neutral, and the blank-line removal is cosmetic.

## Oracle
`./check.sh`: test/walbig.test walbig-1.2 and walbig-1.3 fail. After the checkpoint wrote pages to the wrong offsets, the database is "malformed" (`database disk image is malformed` on SELECT). Cases 1.0 and 1.1 pass.
