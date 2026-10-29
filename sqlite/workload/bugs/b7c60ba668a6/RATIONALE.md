# Rationale

Changed `tree/src/wherecode.c` (codeOneLoopStart, LIKE loop counter setup):
`pLevel->iLikeRepCntr |= bRev ^ (pIdx->aSortOrder[nEq]==SQLITE_SO_DESC);`
became `pLevel->iLikeRepCntr |= bRev;`

Reverses the fix.patch hunk in codeOneLoopStart that changed the initial
`OP_Integer` value to `bRev ^ (pIdx->aSortOrder[nEq]==SQLITE_SO_DESC)`. Before the
fix, only reverse scanning (bRev) influenced the ASC/DESC direction of the LIKE
counter; the DESC-ness of the index column was ignored. In 3.54.1 the direction
bit lives in the low bit of iLikeRepCntr (used for OP_IfNot/OP_If, string fixup
p5 and the initial counter), so dropping the DESC xor restores the old behavior.

Oracle failures: like3-4.0, like3-4.1, like3-4.2 (LIKE on a column with a DESC
index, wrong blob/text ordering of results).
