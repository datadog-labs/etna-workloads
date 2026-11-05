# Rationale

File: src/backend/executor/execExpr.c, function ExecInitJsonExpr (two hunks: ON ERROR and ON EMPTY).
Traces to the fix.patch execExpr.c hunks that wrap ExecInitExprRec of the JsonBehavior
expression with `state->escontext = escontext` (soft error handling, rethrown by the
COERCION_FINISH step). I removed that save/switch/restore (and the now-unused
`saved_escontext` variables), so errors in the ON ERROR / ON EMPTY expression (e.g. a
CoerceViaIO or domain check) are thrown hard instead of being handled via the
JsonExpr escontext and reported with the proper error message.

The other fix hunks (COERCION_FINISH steps, error_occurred reset) were left in place;
only the escontext hunk was needed to bring back the failure.

Failing oracle cases:
- src/test/regress||sqljson_jsontable
- src/test/regress||sqljson_queryfuncs
