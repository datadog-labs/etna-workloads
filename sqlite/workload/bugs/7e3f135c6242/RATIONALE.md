# Rationale

## Changed hunk: src/build.c, sqlite3EndTable()

The fix wrapped the `sqlite3ResolveSelfReference(..., NC_GenCol, pX, 0)` call for each generated column in an `if`. If resolution reported errors, it replaced the column expression with a plain NULL. That keeps code generators from adding lookaside-allocated nodes to a schema expression that is malformed.

In version-3.54.1 the same logic exists, but it uses `sqlite3ColumnExpr()` and `sqlite3ColumnSetExpr()`. I removed the error branch, so the resolve call's return value is ignored again, as it was before the fix. A generated-column expression that failed to resolve, such as one containing a subquery, stays in the schema as is.

## Oracle

`gencol1-15.20` fails. The test loads a malformed schema (`b AS((VALUES(1)) IS unknown)`), runs `REPLACE INTO t1 VALUES(9)` and expects `{9 NULL}`. It no longer gets that result, because the bad expression is no longer replaced with NULL. The other 175 cases in the run pass.
