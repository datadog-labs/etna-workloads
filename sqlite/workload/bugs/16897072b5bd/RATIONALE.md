# Rationale

Fix hunk reversed: `where.c` in the fix (`SWAP(pRangeEnd,pRangeStart)` for DESC + `sqlite3VdbeChangeP1(v, addrLikeRep-1, 1)`, and the ASC/DESC-aware `DecrJumpZero`/`JumpZeroIncr` choice at loop end). That made the LIKE two-pass (string, then blob) counter direction-aware.

In 3.54.1 this is `src/wherecode.c` (codeOneLoopStart): `iLikeRepCntr` low bit records ASC/DESC (`bRev ^ (aSortOrder[nEq]==DESC)`), consumed by `whereLikeOptimizationStringFixup` as OP_String8 P5. I changed that line to `|= 0`, so the direction is never recorded and DESC scans use the ASC string/blob pass handling, as before the fix.

Failing oracle cases: like3-3.1 and like3-4.1 (LIKE with ORDER BY x DESC returns wrong order/rows across the string/blob passes). Verified with ./check.sh.
