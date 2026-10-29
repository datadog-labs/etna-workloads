# Rationale

Fix hunk (src/wherecode.c): skip `whereIndexExprTrans()` when `pLevel->iLeftJoin!=0`, so
index-on-expression values are never read from a cursor that may be on a null row.

In 3.54.1 `whereIndexExprTrans` is gone. It was replaced by `IndexedExpr` entries
(`whereAddIndexedExpr` in src/where.c) that `sqlite3ExprCodeTarget` consults in
`exprIdxCover`/indexed-expr lookup (src/expr.c). The LEFT JOIN protection is now
`p->bMaybeNullRow`, which makes expr.c emit `OP_IfNullRow` and fall back to full
evaluation of the expression.

Change: src/where.c `whereAddIndexedExpr`, `p->bMaybeNullRow = 0;` (was set for
JT_LEFT|JT_LTORJ|JT_RIGHT). The expression is again read from the index column even on
the RHS of a LEFT JOIN, giving NULL from the null-row cursor instead of e.g. '!!!'.
The partial-index path (`wherePartIdxExpr`) is untouched.

Oracle failure: join5-6.3.2 (`CREATE INDEX t4i ON t4(y, ifnull(z,'!!!'))`;
`SELECT ifnull(z,'!!!') FROM t3 LEFT JOIN t4 ON x=y` returns NULL instead of `!!!`).
