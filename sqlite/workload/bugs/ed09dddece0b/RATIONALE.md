# Rationale

## Changed hunk (src/select.c, `sqlite3Select`, regAcc allocation loop)
Reverses the fix hunk that added `if( ExprHasProperty(...EP_WinFunc) ) continue;`
to the loop deciding whether to allocate `regAcc`. In 3.54.1 that line reads
`ExprHasProperty(pAggInfo->aFunc[i].pFExpr, EP_WinFunc)` with `continue`; it was removed.
Without it, a min()/max() carrying a FILTER clause counts as a "min/max without FILTER",
so `regAcc` is not allocated. The later code in `updateAccumulator()` (which depends on
`regAcc`) then does not clear the "magnet" register on the first row. As a result the
accumulator registers are not populated when the FILTER excludes all rows.

The other fix hunks (the `bFilterMinMax` handling in updateAccumulator) are already
reshaped in 3.54.1 (guarded by `&& regAcc`), so they are left alone. That guard is
what makes this single revert effective.

## Oracle failures
filter1-3.1 hits `Assertion memIsValid(&aMem[pOp->p1])` in sqlite3VdbeExec (an
uninitialized accumulator register is read). The testfixture then aborts, so
filter1-3.1 through 8.0 are reported as failing (21 of 35).
