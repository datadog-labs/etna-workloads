# Rationale

## Change
`tree/src/window.c`, `sqlite3WindowAttach()`: `ExprSetProperty(p, EP_WinFunc|EP_FullSize)` -> `ExprSetProperty(p, EP_WinFunc)`.

## Fix hunk reversed
The fix's `dupedExprStructSize()` hunk added `|| p->pWin` so that an Expr owning a Window is always duplicated at full size, even with EXPRDUP_REDUCE (used when CREATE VIEW / schema parsing duplicates the select). In 3.54.1 that line is now `ExprHasProperty(p, EP_FullSize)`, and window function Exprs get that flag in `sqlite3WindowAttach()`. Dropping the flag there restores the pre-fix behaviour: a window-function Expr can be reduced during duplication, so its `y.pWin` is lost or the Expr is corrupted.

## Oracle failure
`window1-8.0` (CREATE VIEW using window functions) aborts with the assertion `(ExprUseXList(p) && p->x.pList==0) || p->pRight==0` in `sqlite3ExprDeleteNN`. Cases after it in window1.test are not reached.
