# Rationale

Fix 1f4dba87 (2016-08-01): `(select min(a) FROM j1) IN (?, ?, ?)` — an IN whose
LHS is a sub-select (a scalar aggregate one) — was mishandled because code
tested `flags & EP_xIsSelect` (is it a sub-select?) where it needed to ask
whether the LHS is really a vector (the fix's `exprVectorField`,
`exprExtractVectorField` and `sqlite3ExprIsVector` hunks).

## Change (src/whereexpr.c, exprAnalyze, vector-IN term splitting)
The condition `pExpr->pLeft->op==TK_VECTOR` is widened to
`(pLeft->op==TK_VECTOR || (pLeft->flags & EP_xIsSelect))`. This restores the
pre-fix confusion between "is a sub-select" and "is a vector". A scalar
sub-select on the LHS is then split into per-field virtual terms as if it
were a vector. For an IN with a value list on the RHS this reaches
`ALWAYS(ExprUseXSelect(pExpr))` failing (assert in debug builds).

The other fix hunks (removal of checkForMultiColumnSelectError, renames,
comment edits) do not affect behaviour and were not reverted.

## Oracle failure
`rowvalue-8.1` (the test added by the fix) fails with
`exprAnalyze: Assertion '0' failed.` in the oracle build.
