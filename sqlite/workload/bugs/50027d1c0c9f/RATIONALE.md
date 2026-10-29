# Rationale

Fix hunk: in `OP_Concat` (src/vdbe.c), add `ExpandBlob(pTerm)` before stringifying each operand, so a zeroblob (MEM_Zero) operand is materialized before concatenation.

In 3.54.1 the logic lives in `case OP_Concat`. The equivalent of `ExpandBlob` is the two `else if( (flagsN & MEM_Zero)!=0 ){ sqlite3VdbeMemExpandBlob(pInN) ... }` branches, one each for P1 and P2. I removed both, so zeroblob operands are no longer expanded. Their `z`/`n` hold only the non-zero prefix (empty for `zeroblob(N)`), so the concat result drops the zero bytes.

Oracle failure: `zeroblob-4.1` (`SELECT hex(zeroblob(2) || x'61')` returns `61` instead of `000061`). The other 55 cases pass.
