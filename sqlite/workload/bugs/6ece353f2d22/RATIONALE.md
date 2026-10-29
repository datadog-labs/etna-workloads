# Rationale

Fix: "expr IS TRUE COLLATE xyz" must be handled like "expr IS TRUE" (ticket 4d01eda8115b10d1).

## Hunks changed
- `src/resolve.c`, TK_IS/TK_ISNOT in resolveExprStep: reverses the fix hunk that computes
  `pRight = sqlite3ExprSkipCollate(pExpr->pRight)`. Now `pRight = pExpr->pRight` (the 3.54.1 code
  also skipped LIKELY; both skipping helpers are dropped). With a COLLATE wrapper, pRight->op is
  TK_COLLATE, so the IS TRUE/FALSE special case (TK_TRUTH) is never taken.
- `src/expr.c`, sqlite3ExprTruthValue: removes the `sqlite3ExprSkipCollate...` call added by the fix.
- The treeview.c assert hunk is debug-only and not reverted.

## Oracle failure
`istrue-710` fails: expected `1 1 1 1 1 1 1 1 1`, got `0 0 0 1 1 1 1 1 1`
(`0.5 IS TRUE COLLATE NOCASE/RTRIM/BINARY` yield 0 instead of 1).
