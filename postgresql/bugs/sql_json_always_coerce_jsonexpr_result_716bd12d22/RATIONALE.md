# Rationale

Changed hunk: `src/backend/parser/parse_expr.c`, `transformJsonFuncExpr()`, case `JSON_QUERY_OP`.

Traces to the fix.patch hunk that replaces `coerceJsonExprOutput(pstate, jsexpr)` with
`if (jsexpr->returning->typid != JSONBOID || jsexpr->omit_quotes) jsexpr->use_json_coercion = true;`.
I removed the `|| jsexpr->omit_quotes` condition. JSON_QUERY ... RETURNING jsonb OMIT QUOTES
then no longer sets up the runtime coercion, so the result is not coerced and the quotes are kept.
The result of a JsonExpr is therefore not always coerced at runtime.

Failing oracle cases:
- src/test/regress||sqljson_jsontable
- src/test/regress||sqljson_queryfuncs
