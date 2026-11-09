# Rationale
All hunks in tree/src/compiler/checker.ts, reversing the fix's three hunks:
1. In resolveNameHelper's lazy diagnostic, removed `errorLocation.parent.kind !== SyntaxKind.JSDocLink &&` guard, so unresolved names in {@link} report errors again.
2. getSymbolOfNameOrPropertyAccessExpression: resolveEntityName ignoreErrors true -> false.
3. resolveJSDocMemberName call there: ignoreErrors true -> false.
Result: JSDoc names in .ts files issue spurious errors (tsserver goToDefinition, symbol baselines).

Final: SUMMARY: 10/82 oracle cases failing (1 fix-added).
