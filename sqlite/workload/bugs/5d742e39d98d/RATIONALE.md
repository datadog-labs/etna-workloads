# Rationale

Fix reversed: ticket 5981a8c041a3c2f3. Before the fix, an OP_SeekScan on a
loop with a range constraint after the IN term jumped (P2) past the OP_IdxGT,
skipping the code that loads the range-end value. The range-end register was
left holding the range-start value, giving a wrong answer.

The fix's hunks (`pLevel->p2` set before the range-end load, `if( pLevel->p2==0 )`)
cannot be reversed literally: in 3.54.1 the problem is handled differently.
When `pRangeStart || pRangeEnd`, the seek-scan gets P5=1, its P2 points just past
the OP_SeekGE (so the range-end load is never skipped), and `addrSeekScan` is
cleared. That also explains `assert( addrSeekScan==0 )` in the pRangeEnd block.

Change (src/wherecode.c, sqlite3WhereCodeOneLoopStart):
- Removed the `if( pRangeStart || pRangeEnd ){ P5=1; P2=...; addrSeekScan=0; }`
  block after OP_SeekScan is emitted. addrSeekScan stays set when a range is
  present, so the later `sqlite3VdbeJumpHere(v, addrSeekScan)` after OP_IdxGT
  points OP_SeekScan.P2 past the range-end initialization. This is the
  pre-fix behavior the fix's `pLevel->p2 = CurrentAddr` hunk guarded against.
- Removed `assert( addrSeekScan==0 )` in the pRangeEnd block, which no longer holds.

Oracle: test/in4.test in4-13.0 fails (the fix's added test):
expected `10 1 2 5 20 1 3 5 30 1 2 4 40 1 3 4`, got `10 1 2 5 30 1 2 4 40 1 3 4`
(row 20 lost). The other 83 cases pass.
