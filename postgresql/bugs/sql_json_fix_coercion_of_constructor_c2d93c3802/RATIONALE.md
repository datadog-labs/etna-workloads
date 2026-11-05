# Rationale

## src/backend/parser/parse_expr.c, coerceJsonFuncExpr()
Traces to the fix.patch hunk that changes the `coerce_to_target_type` call from
`COERCION_EXPLICIT`/`COERCE_EXPLICIT_CAST` to implicit casts when the typmod is > 0.
In the current code the call uses assignment-level, implicit casts. I changed it back to
`COERCION_EXPLICIT` / `COERCE_EXPLICIT_CAST`. An explicit cast to a typmod type such as
varchar(2) or char(2) truncates silently instead of raising "value too long". This
restores the bug.

The other fix hunks (the `baseTypmod` computation, and the text conversion in
`makeJsonConstructorExpr`) have no direct counterpart in the current code, which has since
been restructured. The change above is enough to bring the bug back.

## Failing oracle cases
- src/test/regress||sqljson
