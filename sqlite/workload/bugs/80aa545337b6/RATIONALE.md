# Rationale

## Hunk changed: src/expr.c, sqlite3ExprAffinity()
Reverses the fix hunk that added the `op==TK_SELECT_COLUMN` branch. I removed
the equivalent branch in 3.54.1, which returns the affinity of the matching
result column of the sub-select. Without it, a TK_SELECT_COLUMN node falls
through to `pExpr->affExpr`, so the sub-select element's affinity is ignored
in row-value assignments and comparisons, as before the fix.

## Oracle failures
test/rowvalue9.test: rowvalue9-3.6 and 4.1.4 through 4.8.4, all of the form
`(a, b) = (SELECT x, y ...)`. They return wrong results because the affinity
is ignored. types2 is unaffected.
