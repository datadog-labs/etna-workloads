# Rationale
- `module.ts` visitLabeledStatement: fix.diff replaced `Debug.checkDefined(visitNode(...))` with a `??` fallback. Today's fallback is `setTextRange(factory.createEmptyStatement(), node.statement)`; I restored `Debug.checkDefined(visitNode(...))`, so a labeled `export` declaration (visited to undefined) crashes with "Debug Failure".
- `system.ts` visitLabeledStatement: same change (fallback was `createExpressionStatement(createIdentifier(""))`).

Final: SUMMARY: 12/18 oracle cases failing (12 fix-added).
