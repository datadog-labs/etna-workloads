# Rationale
- src/backend/parser/parse_expr.c, transformJsonFuncExpr (JSON_TABLE_OP case): default ON ERROR passed JSON_BEHAVIOR_EMPTY_ARRAY; restored to JSON_BEHAVIOR_EMPTY (fix hunk 1, comment too). The wrong default behavior is used for JSON_TABLE when ON ERROR is unspecified.
- src/backend/utils/adt/ruleutils.c, get_json_table: compare against JSON_BEHAVIOR_EMPTY instead of EMPTY_ARRAY (fix hunk 2), so deparse is consistent with the buggy default.

Failing oracle case: src/test/regress||sqljson_jsontable
