# Rationale

Bug: SeekScan skipped valid rows for `a IN (...) AND b >= ?` (dbsqlfuzz ab1db6dc). The fix added
`OP_SeekScan.P5` and, in wherecode.c, set P5=1 / P2=next-addr when a range constraint follows the IN.
In 3.54.1 that logic lives in `sqlite3WhereCodeOneLoopStart` (extended to `pRangeStart || pRangeEnd`).

## Changes (src/wherecode.c)
1. Removed the `if( pRangeStart || pRangeEnd ){ ChangeP5(1); ChangeP2(...); addrSeekScan = 0; }` block.
   This reverses the fix's wherecode.c hunk (which originally was `if( pRangeStart )`). SeekScan is again
   always emitted with P5=0, so on overshoot it jumps to SeekGE.P2, ending the loop and skipping valid rows.
   The vdbe.c P5 handling is left intact; it is simply never exercised with P5!=0.
2. Removed `assert( addrSeekScan==0 );` in the `pRangeEnd` code. It was only valid thanks to the removed
   block (added with the pRangeEnd extension); without removal debug builds abort instead of giving the
   original wrong result.

## Oracle
seekscan1-1.2, 1.3, 1.5 fail with wrong results (rows missing, e.g. `abc 345 7`).
