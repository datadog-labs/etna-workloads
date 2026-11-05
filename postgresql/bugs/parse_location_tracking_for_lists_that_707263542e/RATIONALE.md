# Rationale

## src/backend/parser/gram.y, YYLLOC_DEFAULT macro
Traces to the fix.patch hunk changing YYLLOC_DEFAULT (and the OptSchemaEltList `if (@$ < 0) @$ = @2;` fix).
In current code the macro scans the RHS for the first non-negative location, which is what makes
empty-able list nonterminals work (the per-rule `@$ = @2` fix is no longer needed). I restored the
pre-fix macro: `if (N > 0) Current = Rhs[1]; else Current = -1;`. A list nonterminal such as
OptSchemaEltList then gets -1 from its empty reduction and copies it on every subsequent reduction, so
the parse location of a non-empty list is -1 (e.g. CREATE SCHEMA element errors lose their cursor position).

## Failing oracle cases
- src/test/regress||namespace
