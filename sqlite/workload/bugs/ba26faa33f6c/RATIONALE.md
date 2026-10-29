# Rationale

Fix hunk (src/wherecode.c) replaced `sqlite3ReleaseTempRange(pParse, iReg, nConstraint+2);`
at the end of the virtual-table branch of sqlite3WhereCodeOneLoopStart() with a comment,
so the argument registers stay allocated while an IN loop is active.

In version-3.54.1 the same code exists (src/wherecode.c, end of the virtual-table case,
after the loop that emits the SQLITE_JUMPIFNULL compare). I reverted the hunk: removed the
comment and restored the `sqlite3ReleaseTempRange(pParse, iReg, nConstraint+2);` call.
(`sqlite3ExprCachePop` no longer exists, so that line of the hunk context is not relevant.)

Oracle: bestindex1-3.5 fails (returns only 2 of the 4 rows) because the released registers
get reused and overwritten while the outer IN loop on a virtual table is running.
