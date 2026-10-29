# Rationale

Fix: add `|| pExpr->y.pWin` to the "not constant" condition in `exprNodeIsConstantFunction()` (src/expr.c), so a non-aggregate function with an OVER clause (e.g. `zeroblob(300) OVER win` in a multi-row VALUES) is not treated as constant.

In 3.54.1 that case is covered by two places, so I reverted both. They are the same defect (a window function treated as a constant function):

1. `exprNodeIsConstantFunction()`: removed `|| NEVER(ExprHasProperty(pExpr, EP_WinFunc))`. This is the fix's added line, in its current form.
2. `exprNodeIsConstant()`, `case TK_FUNCTION`: removed the up-front `if( ExprHasProperty(pExpr, EP_WinFunc) ){ eCode=0; return WRC_Abort; }` branch. This later check made hunk 1 unreachable, which is why reverting hunk 1 alone changed nothing.

## Oracle
`values-13.1` (`VALUES(300), (zeroblob(300) OVER win)`) no longer yields the error "zeroblob() may not be used as a window function". The function is treated as constant, and the run dies with `Assertion memIsValid(&pMem[i]) failed` in sqlite3VdbeExec, so the file's run is incomplete.
