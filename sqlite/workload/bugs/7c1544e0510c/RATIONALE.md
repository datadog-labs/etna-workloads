# Rationale

## src/select.c, substExpr()
Reverses the single fix hunk. The fix turned
`else if( op==TK_IF_NULL_ROW && iTable==pSubst->iTable ){ rewrite }else{ recurse }`
into an `else{ if(IF_NULL_ROW...) rewrite; recurse }` so the rewriter also descends into
the children of TK_IF_NULL_ROW. I restored the `else if` form: after rewriting iTable of a
TK_IF_NULL_ROW node, pLeft/pRight/etc. are no longer substituted (the TK_AGG_FUNCTION
adjustment, which did not exist in 2017, stays in the recursing branch).

## Oracle
join-14.3 (`LEFT JOIN (SELECT cc+222, * FROM (SELECT * FROM (SELECT 333 cc)))`) fails:
the unsubstituted column inside TK_IF_NULL_ROW refers to the removed subquery cursor,
giving `Assertion 'pC!=0' failed` in sqlite3VdbeExec.
