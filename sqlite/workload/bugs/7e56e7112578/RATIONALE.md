# Rationale

Fix (CVS 2769, ticket #1514) added a guard in `sqlite3ExprCodeTarget` (expr.c, `case TK_AGG_FUNCTION`):
if `pExpr->pAggInfo==0` (an aggregate used where no aggregate context exists, e.g. in WHERE
of a GROUP BY query) report "misuse of aggregate" instead of dereferencing the NULL AggInfo.

## Change
`src/expr.c`, `case TK_AGG_FUNCTION` in `sqlite3ExprCodeTarget`: removed the `pInfo==0`
(and the later-added `iAgg` range NEVER()) check and error, restoring the pre-fix
unconditional `AggInfoFuncReg(pInfo, pExpr->iAgg)` (the modern equivalent of
`OP_MemLoad pInfo->aFunc[iAgg].iMem`). With a NULL pAggInfo this dereferences NULL.

## Oracle
`tkt1514-1.1` (`SELECT a FROM t1 WHERE max(b)<10 GROUP BY a;`) now crashes the test
run instead of returning `1 {misuse of aggregate: max(b)}`.
