# Rationale

Fix hunk (src/select.c, substExpr): when flattening, copy `pExpr->pColl` (the
explicit collation on the parent's expression) onto the substituted `pNew`
so it is not discarded.

In 3.54.1 explicit collations are TK_COLLATE wrapper nodes, not `Expr.pColl`.
The equivalent regression: in `substExpr()` (tree/src/select.c), when the
parent-query node is a TK_COLLATE, it is dropped after its operand is
substituted and only the operand is returned. The explicit COLLATE of the
parent query is thus discarded during flattening, as before the fix.

Failing oracle cases: tkt3997-1.3 (ORDER BY name COLLATE reverse over a
flattened subquery returns binary order) and tkt3997-2.3 (COLLATE usual
ignored; column's collation `reverse` is used instead).
