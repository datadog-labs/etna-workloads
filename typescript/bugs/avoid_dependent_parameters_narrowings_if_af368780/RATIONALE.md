checker.ts hunk 1 (getNarrowedTypeOfSymbol, binding element on parameter): `isSomeSymbolAssigned(rootDeclaration)` -> `isSymbolAssigned(symbol)`; corresponds to fix hunk 2. Only the single binding's symbol is checked, so assignment to a sibling binding element no longer disables dependent narrowing.
checker.ts hunk 2 (rest-tuple contextual parameters): `!some(func.parameters, isSomeSymbolAssigned)` -> `!isSymbolAssigned(symbol)`; corresponds to fix hunk 3. Assignment to another parameter no longer disables narrowing.
The helper functions (fix hunk 1) remain since today's code uses them elsewhere; types.ts hunk is comment whitespace only, skipped.

SUMMARY: 1/12 oracle cases failing (0 fix-added).
