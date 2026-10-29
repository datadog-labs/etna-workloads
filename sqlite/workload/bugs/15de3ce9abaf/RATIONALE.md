# Rationale

Fix: in exprAnalyze() (src/whereexpr.c), when `x IS NULL` is rewritten to TK_TRUEFALSE
because x cannot be NULL, the fix added `pExpr->u.zToken = "false"`. Without it the node
is TK_TRUEFALSE with a stale/NULL zToken, and sqlite3ExprTruthValue() dereferences it.

Changes in tree/src/whereexpr.c (TK_ISNULL branch of exprAnalyze):
1. Removed `pExpr->u.zToken = "false";` - reverses the fix hunk directly.
2. Removed `&& !ExprHasProperty(pExpr,EP_OuterON)` from the branch condition. Later code
   added this guard, which keeps the rewrite from firing for ON-clause terms of a LEFT JOIN,
   so it covered the oracle case (`... LEFT JOIN t3 ON a IS NULL`) from another path.
   Dropping it restores the pre-fix condition (rewrite whenever the column can't be NULL).

Oracle: notnull2-2.1, 3.0, 3.1, 4.0, 4.1, 5.0 fail. The testfixture (assert-enabled) aborts at
sqlite3WhereBegin `pT->prereqAll!=0 || !ExprHasProperty(pX, EP_OuterON)`, because the
rewritten term has prereqAll=0 in an outer-join ON clause; without asserts the bad TRUEFALSE
node (no zToken) is the segfault described in the fix. Note: the observed failure is
this assert, not the exact zToken NULL dereference, since the assert fires first.
