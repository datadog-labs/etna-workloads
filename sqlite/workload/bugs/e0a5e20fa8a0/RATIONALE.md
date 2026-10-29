# Rationale

## Change
`tree/src/window.c`, `windowReturnOneRow()`, lead()/lag() branch:
`int iEph = pMWin->iEphCsr;` -> `int iEph = pWin->iEphCsr;`

Reverses the fix hunk `-int iEph = pWin->iEphCsr; +int iEph = pMWin->iEphCsr;`.
The ephemeral table cursor is allocated only on the master window (pMWin), so for
the 2nd and later window functions in a query, pWin->iEphCsr is not the real
cursor. Same code as before the fix.

The other fix hunk (`nPart = pPart ? ... : 0` in windowPartitionCache) was
only a cleanup with no behaviour change, so it was not reverted.

## Oracle failures
- window4-7.4: expected `4 4 6 6 ...`, got `2 4 2 6 2 8 ...` (wrong result).
- window4-7.5: assertion failure in sqlite3VdbeExec (`p2<(u32)pC->nField`) -> crash.
