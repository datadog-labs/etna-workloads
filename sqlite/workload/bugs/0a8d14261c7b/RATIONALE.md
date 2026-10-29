# Rationale

Fix hunk (src/parse.y): `x IN (?)` → `x==(+? COLLATE binary)` instead of plain `x==?`.
Pre-fix code was `pRHS = Y->a[0].pExpr; ... sqlite3PExpr(TK_EQ, X, pRHS)`.

Changes in tree/src/parse.y (IN-with-one-value branch):
1. Removed the `pRHS = sqlite3PExpr(pParse, TK_UPLUS, pRHS, 0);` wrapper (reverses the fix's added TK_UPLUS hunk;
   RHS again takes part in affinity/collation of the `==`).
2. Removed the `sqlite3ExprIsConstant(pParse,pRHS)` condition. In 3.54.1 this later guard keeps column RHS
   from being converted, so it masks the same defect; the original (pre-fix) code converted any single-value RHS.
   (The fix's COLLATE-binary hunk has no current counterpart; 3.54.1 never had the COLLATE binary wrapper, so nothing to remove.)

Failing oracle cases: in4-4.6 (`(a||'') IN (b)` wrongly uses b's NOCASE collation) and in4-4.17
(`a IN (b)` with TEXT a / NUMERIC b applies affinity), both added by the fix; also in4-5.1 and in4-11.2
(EXPLAIN/plan-shape expectations altered by the conversion).
