# Rationale

## src/backend/parser/parse_coerce.c, coerce_type_typmod()
Traces to the fix.patch hunk in coerce_type_typmod. The current code handles a negative
typmod by forcing pathtype = COERCION_PATH_NONE so a RelabelType is still applied. I
restored the old early return `if (targetTypMod < 0 || targetTypMod == exprTypmod(node)) return node;`.
A cast to typmod -1 is then elided, so the expression keeps its old typmod instead of
exposing -1 (for example, casting a varchar(n) value to plain varchar).

The now-unreachable `targetTypMod < 0` branch further down is left in place. This keeps the change minimal.

## Failing oracle cases
src/test/regress||expressions (expected; see the oracle run)
