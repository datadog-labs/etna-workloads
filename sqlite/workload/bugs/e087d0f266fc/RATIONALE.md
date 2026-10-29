# Rationale

## Change
`tree/src/whereexpr.c`, `exprAnalyze()`: the TK_OR branch condition
`pExpr->op==TK_OR && !ExprHasProperty(pExpr, EP_Collate)` is restored to
`pExpr->op==TK_OR`.

This reverses the single implementation hunk of the fix (which added the
`!EP_Collate` guard). The surrounding code (sqlite3ExprSimplifiedAndOr) has
changed since, but the line itself still matches, so reverting it restores
the pre-fix behaviour: the OR-optimization (exprAnalyzeOrTerm) is again
attempted on OR terms containing COLLATE operators.

## Oracle results
- bestindexC-5.8 and 5.9 fail: they now return rows
  (`zero two three`, `zero four two three six seven`) instead of the
  expected `1 {no query solution}`.
- where2-17.0/17.1 still pass (the wrong-result case from the bug report
  does not reproduce in this tree).
