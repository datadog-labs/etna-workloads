# Rationale

## src/where.c, whereUsablePartialIndex()
Fix hunk: added `&& (pTerm->wtFlags & TERM_VNULL)==0` to the condition that
decides whether a WHERE term implies the partial-index WHERE clause. I removed
that line from the same condition in 3.54.1 (the surrounding code gained an
extra `sqlite3ExprImpliesExpr(..., -1)` check and renamed EP_FromJoin to
EP_OuterON, but the structure is otherwise the same). The manufactured
`a>NULL` term made from `a IS NOT NULL` is again treated as implying a partial
index `WHERE a>NULL`, so the unusable index is chosen.

## Oracle failures
index6-18.1: `SELECT * FROM t1 WHERE a IS NOT NULL` returns `{}` instead of
`{10 10}` (the partial index is empty because `a>NULL` is never true).
