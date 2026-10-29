# Rationale

Fix hunk (src/select.c, findConstInWhere): skip WHERE terms marked `EP_OuterON|EP_InnerON`
instead of only `EP_OuterON`, so constant propagation never crosses ON/WHERE boundaries.

In 3.54.1 that check became `ExprHasProperty(pExpr, pConst->mExcludeOn)`, with `mExcludeOn`
set in `propagateConstants()`: `EP_InnerON|EP_OuterON` if the query has a RIGHT JOIN
(`JT_LTORJ` on the first FROM item), else only `EP_OuterON`.

Change: `propagateConstants()` now always sets `x.mExcludeOn = EP_OuterON`, removing the
RIGHT JOIN branch. Inner-ON terms (`EP_InnerON`) are then propagated even with a RIGHT JOIN,
which is the pre-fix behavior. `findConstInWhere` and `propagateConstantExprRewrite`
(which both read `mExcludeOn`) are unchanged.

Oracle failure: join8-22020 (`SELECT * FROM t1 JOIN t3 ON (b=TRUE) RIGHT JOIN t2 ON TRUE
WHERE (b IS TRUE)`) returns 4 empty-row results instead of none. The ON term `b=TRUE`
is propagated into the WHERE term `b IS TRUE`, which confuses the RIGHT JOIN.
