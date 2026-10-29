# Rationale

Fix: CTE resolution did not count nesting depth against SQLITE_LIMIT_EXPR_DEPTH.

Changed `resolveFromTermToCte()` in `tree/src/select.c`:
- Removed `pParse->nNestSel++` and `checkSubqueryNestingDepth(pParse)` (return 2) before walking the CTE body. This reverses the fix hunk at `pCte->zCteErr = "circular reference: %s"`.
- Removed the matching `pParse->nNestSel--` / assert after the walk. This reverses the second fix hunk.

The `checkSubqueryNestingDepth()` helper stays, because `sqlite3ResultSetOfSelect` still uses it (as it did after the fix). The later nTab-based block (Bug ...05:35:14Z) is left alone; it is a separate fix.

Oracle: `with2-14.2` fails. It expects "VIEWs and/or subqueries nested too deep" and gets `0 1`, because chained CTEs are no longer depth-limited.
