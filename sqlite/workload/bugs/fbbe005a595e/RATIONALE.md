# Rationale

Fix hunk (src/select.c, substExpr): added `pExpr->pTab = pNew->pTab;` so that a
column substituted from a subquery/view (query flattening) carries the
substituted expression's Table pointer. Without it a virtual-table column
reference keeps the stale (subquery) table.

In 3.54.1, substExpr no longer copies fields one by one; it replaces pExpr with
a full `sqlite3ExprDup` of the subquery's result expression, so pTab is copied
implicitly. Re-expressed bug (src/select.c, substExpr): after the dup, a
TK_COLUMN `pNew` gets `pNew->y.pTab = pExpr->y.pTab` (the old, pre-substitution
pTab), i.e. the substituted column does not take the new expression's pTab.
(Skipped for IfNullRow-wrapped copies.)

Oracle failures: vtab6 (joins over virtual tables, subquery/view flattening)
aborts at vtab6-1.13 with assertion `p2<(u32)pC->nField` in OP_VColumn/OP_Column
(wrong table used for the column), and vtab1-20.4 also asserts. This is the
same class of failure as vtab6/vtab1-3.8 guard against.
