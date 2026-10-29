# Rationale

Fix hunk (src/expr.c, sqlite3ExprImpliesExpr): added `pE1->op!=TK_ISNOT` to the
guard so that "x IS NOT ?" is not assumed to imply "x NOT NULL" (partial-index usability).

In 3.54.1 that logic lives in `exprImpliesNotNull()`, which uses a whitelist of
operators. TK_IS/TK_ISNOT are not whitelisted, hence the bug is gone. I re-added
`case TK_ISNOT:` to the list of binary comparison operators (TK_EQ, TK_NE, ...)
in `exprImpliesNotNull()`, so `c0 IS NOT 1` is again treated as implying `c0 NOT NULL`
(the pre-fix behaviour, where only TK_IS/TK_ISNULL/TK_OR were excluded).

Oracle failure: index6-14.1. With partial index `WHERE c0 NOT NULL`, `SELECT * FROM t0
WHERE c0 IS NOT 1` wrongly uses the partial index and misses the row (NULL,'row').
