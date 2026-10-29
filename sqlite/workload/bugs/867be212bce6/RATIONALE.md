# Rationale

Fix hunk (src/walker.c): the walker only visits Expr.y.pWin when the node is
`!EP_Reduced`. A window function inside a view/trigger gets an EXPRDUP_REDUCE
copy, which is truncated before the `y` union, so walking `y.pWin` reads
past the allocation and crashes.

In 3.54.1 the walker has no EP_Reduced test (it only tests EP_WinFunc), so
reversing the hunk is a no-op. The protection now lives in
`sqlite3WindowAttach()` (src/window.c): it sets `EP_FullSize` on the window
function node, so `dupedExprStructSize()` never reduces it. This is the same
defect covered by another path.

Change: src/window.c `ExprSetProperty(p, EP_WinFunc|EP_FullSize)` -> `EP_WinFunc`.
Window-function Exprs can be reduced again, and the walker/delete code
interprets truncated nodes' `y.pWin`.

Oracle results: window1.test aborts at window1-8.0 with
`sqlite3ExprDeleteNN: Assertion (ExprUseXList(p) && p->x.pList==0) || p->pRight==0`
(284 of 334 cases not completed); window4.test aborts from window4-11.2
(10 cases fail).
