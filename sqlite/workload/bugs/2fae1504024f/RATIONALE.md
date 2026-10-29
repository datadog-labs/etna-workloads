# Rationale

## Change: src/expr.c, end of exprDup()
Fix hunk: moved `*pzBuffer = zAlloc` (and the `zAlloc += dupedExprNodeSize`) out of the
`EP_Reduced|EP_TokenOnly` branch so that it runs for every node. In 3.54.1 this is the
`if( pEdupBuf ) memcpy(pEdupBuf, &sEdupBuf, ...)` at the end of exprDup().
Reintroduced bug: the buffer position is propagated back to the parent only when the new
node is `EP_Reduced|EP_TokenOnly`. A non-reduced node (e.g. a window function, which is
always fully sized) inside a reduced expression tree (view/subquery expression such as
`ntile(256) OVER (...) - 1`) therefore doesn't advance the parent's allocation pointer,
and the next sibling overwrites it.

## Oracle failures
window4-11.3 (`SELECT * FROM v8` with view `NTILE(256) OVER (ORDER BY total) - 1`):
expected `0 1 2`, got `0 0 0`.
