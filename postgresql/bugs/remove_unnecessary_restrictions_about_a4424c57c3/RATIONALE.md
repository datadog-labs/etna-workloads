# Rationale

File: src/backend/parser/parse_expr.c, function transformAExprIn() (single logical change, traces to the transformAExprIn hunks of fix.patch).

- Re-added `haveRowExpr`, set when the lefthand or any righthand IN item is a RowExpr.
- ScalarArrayOpExpr is only attempted when `!haveRowExpr`.
- In the boolean-tree loop, if `haveRowExpr` is set, every item must be a RowExpr, otherwise the error "arguments of row IN must all be row expressions" is raised.

This restores the unnecessary restrictions on RowExprs in IN lists: row IN with mixed row/non-row items (e.g. a row IN with a composite-typed value) is rejected, and ROW IN lists never use ScalarArrayOpExpr.

Failing oracle case: src/test/regress||rowtypes
