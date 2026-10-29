# Rationale

Fix (ticket #2296) reworked `matchOrderbyToColumn` in select.c so that an ORDER BY
term in a compound SELECT is matched to result columns *by name* (AS name, or the
name of the column expression's token), rather than by the old
`zName` + `sqlite3ExprCompare` mix. In 3.54.1 that logic lives in
`resolveCompoundOrderBy` / `resolveAsName` / `resolveOrderByTermToExprList`
(src/resolve.c). The only path that can match an unaliased result column
(`SELECT b ... UNION ... ORDER BY b`) is the `sqlite3ExprCompare` loop in
`resolveOrderByTermToExprList`.

## Change (src/resolve.c)
Removed the `sqlite3ExprCompare` loop in `resolveOrderByTermToExprList`, so ORDER BY
terms match only via AS-names (`resolveAsName`) -- i.e. the pre-fix "only when
`zName` is set" behaviour, without the fix's name-of-expression matching for
unaliased columns. The select.c hunk's replaced old-matching is thereby re-expressed.
The expr.c hunk (propagating sqlite3Select errors in sqlite3CodeSubselect) is already
present in 3.54.1 (`rc`/`TK_ERROR` handling) and was left untouched.

## Oracle failures (test/select1.test)
select1-6.10, select1-6.22 (ORDER BY b inside an IN subquery compound: "ORDER BY
term does not match any result column"), select1-12.9, select1-12.10.
