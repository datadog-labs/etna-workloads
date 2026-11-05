# Rationale

File: src/backend/parser/parse_expr.c, function transformJsonFuncExpr (JSON_QUERY_OP and JSON_VALUE_OP cases).

Traces to the first two hunks of fix.patch. ON EMPTY is again transformed only `if (func->on_empty)`. The default NULL ON EMPTY behavior is therefore never set when ON EMPTY is omitted, so the default is not enforced. The fix made the transform unconditional.

Failing oracle cases: src/test/regress||sqljson_jsontable and src/test/regress||sqljson_queryfuncs (both FAIL).
