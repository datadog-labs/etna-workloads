# Rationale

## Changed: `sqlite3ExprImpliesNonNullRow()` in src/expr.c
Reverses the second hunk of fix.patch. The fix replaced a `while` loop that
repeatedly stripped TK_NOTNULL (and walked TK_AND) with a single strip of one
TK_NOTNULL. Version 3.54.1 has an if/else form with the same AND handling, so
I restored the original loop: `x NOTNULL NOTNULL` is again reduced to `x`, so
`(b IS NOT NULL) IS NOT NULL` wrongly implies that `b`'s table is non-null.
The LEFT JOIN is then converted to an inner join and the NULL-extended row is lost.

The first hunk (TK_AND in the walker callback) is not reverted. 3.54.1 handles
that case through `bothImplyNotNullRow()`, which is a different design.

## Oracle failures
join-19.1, join-19.3 and join-19.5 fail. Each returns no rows where the expected
result is a row with a NULL.
