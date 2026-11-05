# Rationale

File: src/backend/utils/adt/ruleutils.c, function get_json_expr_options (single hunk of fix.patch).

Reverted the fix: removed the `else if (wrapper == JSW_NONE || JSW_UNSPEC)` branch that emits
" WITHOUT WRAPPER", and the `else` branch that emits " KEEP QUOTES". Deparsed JSON_QUERY
(and JSON_TABLE columns) then omit the explicit WRAPPER/QUOTES clauses for the default cases.

Failing oracle cases:
- src/test/regress||sqljson_jsontable
- src/test/regress||sqljson_queryfuncs
