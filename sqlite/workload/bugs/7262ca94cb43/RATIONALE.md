# Rationale

## Changed hunk
`tree/src/resolve.c` (resolveExprStep): the window-function misuse check was
changed from `if( pDef && pDef->xValue==0 && pWin )` back to
`if( is_agg==0 && pWin )`.

This reverses the fix's resolve.c hunk (`is_agg==0 && pExpr->pWin` ->
`pDef && pDef->xValue==0 && pExpr->pWin`). With the old condition, a regular
aggregate (xFinalize set, no xValue/xInverse), such as a user-overridden
`sum()`, is no longer rejected when used with OVER. The window code then calls
sqlite3VdbeMemAggValue() on a function with `xValue==0`.

The other fix hunks (countInverse, window.c row-expr step) are not reversed.
In 3.54.1 they were rewritten and are not needed to trigger this bug.

## Oracle failures
- window5-3.0: `sum(a) OVER (...)` after `test_override_sum` hits assertion
  `pFunc->xValue!=0` in sqlite3VdbeMemAggValue (a segfault in non-debug builds).
- window5-3.1: not reached after the crash (incomplete run).
