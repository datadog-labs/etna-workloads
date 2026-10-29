# Rationale

## Changed: `tree/src/whereexpr.c`, `exprAnalyze()`, the `op==TK_IN` branch

Reverses the `exprAnalyze` hunk of the fix (`pTerm->prereqRight` for TK_IN computed
from `pExpr->pList`/`pExpr->pSelect` instead of `pExpr->pRight`).
In 3.54.1 the right side of IN lives in `x.pList`/`x.pSelect`. The branch used
`exprSelectUsage()`/`sqlite3WhereExprListUsage()`. I restored the pre-fix
computation, `sqlite3WhereExprUsage(pMaskSet, pExpr->pRight)`, which is always 0 for IN
because `pRight==0`. So `prereqRight` ignores tables referenced on the right of IN.
`prereqAll` is computed with `sqlite3WhereExprUsageNN(pExpr)` (the full usage, as the
pre-fix code did), so the debug consistency check at the end of the block still holds.

The `exprSelectTableUsage` refactor hunk is not reverted: `exprSelectUsage` still exists
and is still used by `sqlite3WhereExprUsageFull`. The new assert and comment hunks have no behavioural effect.

## Oracle
`test/tkt1443.test`: tkt1443-1.2 fails (returns an empty result instead of the 5 rows).
This is the query run after the index is created. 1.0 and 1.1 pass.
