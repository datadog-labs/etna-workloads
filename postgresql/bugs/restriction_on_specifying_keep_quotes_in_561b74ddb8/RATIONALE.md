# Rationale

Hunk: `src/backend/parser/parse_expr.c`, `transformJsonFuncExpr()`.
Traces to the single hunk of fix.patch in the same function. The fix changed the check from `func->quotes != JS_QUOTES_UNSPEC` to `func->quotes == JS_QUOTES_OMIT`. Here the check is reverted to `!= JS_QUOTES_UNSPEC`, which sits inside the current `if (func->op == JSON_QUERY_OP) { ... }` block.

Effect: `KEEP QUOTES` combined with `WITH [CONDITIONAL|UNCONDITIONAL] WRAPPER` is wrongly rejected with "SQL/JSON QUOTES behavior must not be specified when WITH WRAPPER is used". Only `OMIT QUOTES` should be rejected.

Failing oracle cases:
- src/test/regress||sqljson_jsontable
- src/test/regress||sqljson_queryfuncs
