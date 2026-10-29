# Rationale

The fix added a nesting counter (`pParse->nNestSel`) to `sqlite3ResultSetOfSelect()`
(src/select.c). It checked the counter against SQLITE_LIMIT_EXPR_DEPTH and
decremented it on success. In 3.54.1 the field and a helper,
`checkSubqueryNestingDepth()`, already exist because the CTE path uses them.
Reversing the fix hunk directly would not apply, since the code is now written
through the helper.

Changes in `sqlite3ResultSetOfSelect()`:
- Removed `pParse->nNestSel++; if( checkSubqueryNestingDepth(pParse) ) return 0;`.
  This reverses the fix's added increment and limit check.
- Removed `pParse->nNestSel--; assert(...)` before `return pTab`. This reverses
  the fix's added decrement. It has to go with the increment, or the assert
  would fail.

The CTE use of `nNestSel` in `searchWith`/`resolveFromTermToCte` is a separate
later fix and is left alone. The sqlite.h.in doc hunk and the field
declaration are not behavioural, so they are unchanged.

## Oracle failures
test/view.test: view-32.2 and view-32.3 fail. With the EXPR_DEPTH limit at 7
and 6, `SELECT * FROM v7` returns `0 7` instead of
`1 {VIEWs and/or subqueries nested too deep}`. View nesting is unbounded again.
