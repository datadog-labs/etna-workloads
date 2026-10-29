# Rationale

The fix (12ad822d) clamped `pWInfo->nOBSat` in `wherePathSolver()` to
`pSelect->pOrderBy->nExpr` for WHERE_DISTINCTBY. In 3.54.1 that clamp is gone;
only an assert remains (src/where.c, "See check-in [12ad822d9b827777]"). The
case is now avoided earlier, in `sqlite3WhereBegin()`: when the ORDER BY has
>=BMS terms, `pOrderBy` is set to 0 *and* `WHERE_WANT_DISTINCT` is cleared,
so the result set is never installed as `pWInfo->pOrderBy` (DISTINCTBY).

## Change (src/where.c, sqlite3WhereBegin)
Removed `wctrlFlags &= ~WHERE_WANT_DISTINCT;` from the "more than 63 terms"
block. With `pOrderBy==0` and WANT_DISTINCT still set, the DISTINCTBY path
(`pWInfo->pOrderBy = pResultSet`) is taken again, so `nOBSat` (computed against
the result set) can exceed the real ORDER BY's `nExpr`. This is the exact
condition the fix's clamp handled (more result terms than ORDER BY terms, all
constant), and nothing else now clamps it.

## Oracle failures
`distinct-10.1` (and following cases) fail: assertion
`pWInfo->pSelect->pOrderBy==0 || pWInfo->nOBSat <= pWInfo->pSelect->pOrderBy->nExpr`
in wherePathSolver fails (in non-assert builds nOBSat would be too large).
