# Rationale

## Hunk changed: src/resolve.c, lookupName(), `if( pParse->bReturning )` branch

Reverses the fix's only implementation hunk. The fix replaced `iCol` with
`sqlite3TableColumnToStorage(pTab, iCol)` when computing the register for a
RETURNING column reference. The change restores the pre-fix computation,
`pExpr->iTable = iBaseReg + (nCol+1)*iTable + iCol + 1`. This uses the schema
column index rather than the storage index, so it is wrong when a table has
virtual generated columns, which take no storage slot.

## Oracle failures
test/returning1.test: returning1-5.4 and returning1-5.5 fail. They use
`t2(a AS (1+1), b)` with `UPDATE ... RETURNING b` / `RETURNING (SELECT b FROM t1)`.
The wrong register is read, so the wrong value is returned.
