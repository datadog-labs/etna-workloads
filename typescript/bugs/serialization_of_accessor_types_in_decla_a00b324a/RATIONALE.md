# Rationale
1. checker.ts (signature-to-type-elements for divergent accessors): removed `symbolMapper` and the `instantiateSignature(..., symbolMapper)` for getter and setter signatures (fix.diff hunk @@ -7386). Instantiated accessor types in mapped/generic types are no longer substituted.
2. expressionToTypeNode.ts serializeTypeOfAccessor: getter path passes `undefined` symbol to createReturnFromSignature (fix hunk @@ -763), so the enclosing symbol type (instantiated) is not found and the declared return type is used.

Final: SUMMARY: 5/30 oracle cases failing (4 fix-added).
