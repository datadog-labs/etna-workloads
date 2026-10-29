# Rationale

Fix: unsetJoinExpr() gained a `nullable` argument so the LEFT JOIN strength
reduction does not clear EP_CanBeNull when the query contains a RIGHT JOIN
(table on the left of a RIGHT JOIN, JT_LTORJ).

In 3.54.1 the fix's hunks are already present (`nullable` parameter, the
`!nullable` test, and the `1` at the pushdown/RIGHT-JOIN sites). The LEFT-JOIN
call site passes `0`, but oracle cases still pass because of a second path:
`impliesNotNullRow()` in src/expr.c (added later) ignores any inner-join ON
term (EP_InnerON) when isRJ (pWalker->mWFlags) is set. Hence a table that is
the left of a RIGHT JOIN (JT_LTORJ) is never LEFT-JOIN-reduced from an inner
join's ON clause, so unsetJoinExpr() never runs on the problem query.

## Change (src/expr.c, impliesNotNullRow)
Removed the block
`if( ExprHasProperty(pExpr, EP_InnerON) && pWalker->mWFlags ) return WRC_Prune;`
This restores the pre-fix reachability: the LEFT JOIN on t2 is simplified
because the ON term `c=''` of the inner join t3 is treated as WHERE, and the
LEFT-site `unsetJoinExpr(..., 0)` (the fix's `pTabList->a[0].fg.jointype &
JT_LTORJ` hunk, which 3.54.1 already has as plain `0`) clears EP_CanBeNull
on NOT NULL column `c`, although t2 can still be NULL-extended via the RIGHT JOIN.
This is the same defect (CanBeNull wrongly cleared/rows wrongly treated as
non-null under RIGHT JOIN) covered a second way.

## Results
`./check.sh`: 21 oracle cases fail, including the fix's own tests
join8-23010 and join8-23020 (wrong empty result instead of `- - - - y`),
plus join8-7010/7011, 10010-10080, 20010-20060, 21010, 25010, 25020, which
guard the same restriction.
