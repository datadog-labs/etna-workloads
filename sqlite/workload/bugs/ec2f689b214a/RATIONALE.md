# Rationale

Fix hunk: in sqlite3ExprListDup(), the assert `pOldExpr->pLeft==pOldExpr->pRight`
(for the first TK_SELECT_COLUMN) was loosened with `|| ExprHasProperty(pOldExpr->pLeft, EP_Subquery)`.

In 3.54.1 the code was restructured (iColumn==0 test became `if( pNewExpr->pRight )`, and
the old assert was dropped). The same spot is the first-column branch, so I re-added the
strict, faulty assert `assert( pOldExpr->pLeft==pOldExpr->pRight );` at the top of that
branch in src/expr.c. Only a debug (assert-enabled) build is affected.

Oracle failure: upfrom1-5.1 (`UPDATE t3 SET (c,b)=(SELECT 3,4) FROM t1,t2` with t2 a UNION ALL view)
aborts with `Assertion 'pOldExpr->pLeft==pOldExpr->pRight' failed` in sqlite3ExprListDup.
