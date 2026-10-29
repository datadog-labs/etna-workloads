# Rationale

Fix hunk reversed: `src/select.c`, `optimizeAggregateUseOfIndexedExpr()`. The fix changed
`nSortingColumn = 0` (when `nColumn==0`) to `nSortingColumn = pGroupBy->nExpr`, so the sorter
keeps every GROUP BY term even when no column is accumulated.

In 3.54.1 that logic had been generalised to
`mx = max(pGroupBy->nExpr-1, max(aCol[j].iSorterColumn)); nSortingColumn = mx+1`.
I restored the pre-fix computation: 0 if `nColumn==0`, else `aCol[nColumn-1].iSorterColumn+1`.
This ignores GROUP BY terms that are not in the result set, so `nSortingColumn` is too small
(it is 0 when no column is used), which is the original defect. The two `assert`s the fix
added remain, since they still hold.

Oracle failure: `tkt-99378-400` returns `0 1` instead of `0 0`. The other 14 cases pass.
