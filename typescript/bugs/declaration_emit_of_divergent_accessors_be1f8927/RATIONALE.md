# Rationale
One hunk, tree/src/compiler/checker.ts (accessor serialization in symbol-to-declaration, set accessor param type, ~line 10871):
`getWriteTypeOfSymbol(p)` -> `getTypeOfSymbol(p)`. Corresponds to the single hunk in fix.diff, which changed the setter parameter type from getTypeOfSymbol to getWriteTypeOfSymbol. Reverting makes divergent accessors in JS classes emit the getter type for the setter parameter in declaration output.
Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
