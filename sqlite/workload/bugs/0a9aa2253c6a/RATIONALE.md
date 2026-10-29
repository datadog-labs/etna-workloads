# Ticket #3791: walker descends into TokenOnly expression nodes

Fix: `sqlite3WalkExpr()` only descends into children when the node is not
`EP_TokenOnly|EP_SpanOnly`. A TokenOnly node is a truncated copy of Expr
(made by `EXPRDUP_REDUCE`, e.g. for a column DEFAULT) that has no
pLeft/pRight/x fields, so walking them reads past the allocation.

In 3.54.1 the check is `!ExprHasProperty(pExpr,(EP_TokenOnly|EP_Leaf))` in
`sqlite3WalkExprNN` (EP_SpanOnly no longer exists). It is also redundant with
EP_Leaf, which is set on parser-built leaf nodes and survives reduction, so
removing only EP_TokenOnly changes nothing observable.

## Changes
1. `src/walker.c`, `sqlite3WalkExprNN`: test only `EP_Leaf` before descending.
   This reverses the fix's `&& !ExprHasAnyProperty(pExpr,EP_TokenOnly|EP_SpanOnly)`.
2. `src/expr.c`, `exprDup`: a copy reduced to TokenOnly size has `EP_Leaf`
   cleared. EP_Leaf is the second path that kept the walker from descending
   into such nodes (the bug is "fixed twice"); without this, hunk 1 has no
   effect. The reduced copy is a different struct, so Leaf's promise
   ("pLeft, pRight, u.pSelect all NULL") is no longer backed by real fields,
   which matches the pre-fix state where nothing marked the node as childless.

## Oracle
`tkt3791-1.1` (`DEFAULT(datetime('now'))`, then INSERT): the walker visits the
TokenOnly `'now'` argument via `sqlite3ExprCodeFactorable` ->
`sqlite3ExprIsConstantNotJoin` and reads nonexistent pLeft/pRight/x.pList.
In the testfixture build this trips the assertion
`pExpr->x.pList==0 || pExpr->pRight==0` in `sqlite3WalkExprNN`
(a crash/garbage read in a release build).
