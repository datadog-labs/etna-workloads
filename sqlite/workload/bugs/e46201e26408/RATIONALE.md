# Rationale

Changed only `fkScanChildren()` in `tree/src/fkey.c`, in the WITHOUT ROWID branch of the self-reference exclusion. The fix's `fkey.c` hunk is reversed there (the comment change is not needed):

- Loop bound `pIdx->nKeyCol` goes back to `pPk->nKeyCol`, with `Index *pPk = sqlite3PrimaryKeyIndex(pTab)` restored. The loop therefore covers the primary key's column count, but the columns come from the parent-key index `pIdx->aiColumn[i]`. The two disagree when the parent index has a different number of columns.
- The right-hand side goes back from `sqlite3Expr(TK_ID, name)` to `exprTableColumn(db, pTab, pSrc->a[0].iCursor, iCol)`.
- The comparison goes back from `TK_IS` to `TK_EQ`, so NULLs are no longer compared null-safely.

Both versions build the same `NOT(cur_a==a AND ...)` shape, so the old code is equivalent to the pre-fix code.

## Oracle failure
`fkey8-3.1` fails. The table has PRIMARY KEY `a` (1 column) and a parent key `(d,e)` (2 columns). Only `d` is compared, so the child row 2 is wrongly treated as the row being deleted and is excluded. `DELETE FROM t2 WHERE a=1` then succeeds, returning `0 {}` instead of `1 {FOREIGN KEY constraint failed}`.
