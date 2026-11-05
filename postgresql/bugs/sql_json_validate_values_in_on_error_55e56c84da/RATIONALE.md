# Rationale

Both hunks are in `src/src/backend/parser/`.

1. `parse_expr.c`, `transformJsonFuncExpr()`. This traces to the fix.patch hunk in `parse_expr.c`.
   I removed the checks that validate `ON ERROR` / `ON EMPTY` behaviors per function:
   - JSON_QUERY accepts only ERROR, NULL, EMPTY [ARRAY], EMPTY OBJECT or DEFAULT.
   - JSON_EXISTS accepts only ERROR, TRUE, FALSE or UNKNOWN on `ON ERROR`.
   - JSON_VALUE accepts only ERROR, NULL or DEFAULT.

   I restored the standalone OMIT QUOTES / WITH WRAPPER check, as it was before the fix.
   Without the validation, the parser accepts invalid combinations such as `JSON_VALUE ... EMPTY ARRAY ON ERROR` and `JSON_EXISTS ... NULL ON ERROR`. The executor then handles them wrongly instead of raising a syntax error.
2. `parse_jsontable.c`, `transformJsonTable()`. This traces to the fix.patch hunk in `parse_jsontable.c`. I reverted the errdetail text to "Only EMPTY or ERROR is allowed in the top-level ON ERROR clause."

Failing oracle cases:
- src/test/regress||sqljson_jsontable
- src/test/regress||sqljson_queryfuncs
