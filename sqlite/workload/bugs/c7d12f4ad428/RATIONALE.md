# Rationale

The original fix added TERM_NOPARTIDX so a WHERE term commuted by `exprCommute()`
(with COLLATE games) would not qualify a partial index. In 3.54.1 that mechanism
is gone: `exprCommute()` instead toggles `EP_Commuted` on the expression when the
two collating sequences differ, and `sqlite3ExprCompare()` (used by
`sqlite3ExprImpliesExpr()` from `whereUsablePartialIndex()`) treats expressions
differing in `EP_Commuted` as non-matching. That is the same defect's current fix.

## Change
`src/expr.c`, `sqlite3ExprCompare()`: the flag comparison
`(pA->flags & (EP_Distinct|EP_Commuted)) != (pB->flags & ...)` is reduced to
`EP_Distinct` only. A commuted term (`c1 <= c0` rewritten as `c0 >= c1` with
different collation) can again match a partial-index WHERE clause `c0 >= c1`
even though the collation used differs. This reverses the fix's effect
(commuted terms must not enable a partial index) via the equivalent present-day path.

## Oracle failure
`index6-16.3` fails: `SELECT 3 FROM t0 WHERE c1 <= c0` returns `{}` instead of `{3}`.
The commuted term wrongly qualifies the partial index `WHERE c0 >= c1`, which
doesn't contain the row under NOCASE.
