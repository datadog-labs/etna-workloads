# Ticket #2407: LIKE prefix dequoted twice

Fix hunk: where.c set `pStr1->flags = EP_Dequoted` on the pattern-prefix
expression so the token (already dequoted by the parser) was not dequoted again.

In 3.54.1 the prefix expression is built in `isLikeOrGlob()` (src/whereexpr.c)
with `sqlite3Expr(db, TK_STRING, z)`, which calls `sqlite3ExprAlloc(..., dequote=0)`.
That is the modern form of "marked as already dequoted". I changed it to call
`sqlite3ExprAlloc(db, TK_STRING, &token, 1)`, so the already-dequoted pattern
text is dequoted a second time. A pattern like `'a%` (from `LIKE '''a%'`)
loses its leading quote.

Oracle: like-6.1 fails (assertion `z[i]` in sqlite3Dequote on the mangled
token; in non-assert builds the leading quote would be stripped and wrong rows returned).
