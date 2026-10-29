# Rationale

## ext/fts3/fts3_expr.c, fts3ExprCheckDepth()
Reverses the single implementation hunk of the fix: the depth test
`if( nMaxDepth<0 )` is changed back to `if( nMaxDepth==0 )`. The tree is
rejected one level too early (off-by-one), so trees of exactly the maximum
allowed depth (SQLITE_FTS3_MAX_EXPR_DEPTH) are wrongly reported as too deep.
The surrounding code is unchanged since the fix (only the return code differs), so the revert is exact.

## Oracle failures
fts3expr3-3.34, 3.38, 3.42, 3.46, 3.50, 3.54, 3.58, 3.62 (balanced AND/OR trees at the
depth limit now give "Error parsing expression") and fts3expr3-4.1.2 (a 3999-term AND
chain, which should parse, now fails).
