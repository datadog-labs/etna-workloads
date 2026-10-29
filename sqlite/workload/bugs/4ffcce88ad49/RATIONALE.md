# Rationale

Fix hunk reversed (src/expr.c, `impliesNotNullRow`): the fix moved `TK_CASE` into the
"always prune" group (no inference about non-null-row) and deleted the separate
`case TK_CASE:` that walked `pExpr->pLeft` and the first WHEN expression.

Change in tree/src/expr.c: removed `TK_CASE` (and its testcase) from the prune group and
restored the original `case TK_CASE:` block verbatim. That is exactly the pre-fix code, so
`CASE WHEN t2.b THEN 0 ELSE 1 END` is wrongly treated as implying t2 is non-null, and
the LEFT JOIN is strength-reduced to an inner join.

Oracle: joinH-6.1 fails (`SELECT * FROM t1 LEFT JOIN t2 ON true WHERE CASE WHEN t2.b THEN 0 ELSE 1 END`
returns no rows instead of `3 NULL`). The other 81 cases pass.
