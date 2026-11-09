# Rationale
- checker.ts `getLiteralTypeFromPropertyName`: fix.diff replaced the old identifier/else-checkExpression body with a getPropertyNameForPropertyNameNode-based one. Restored the old body, so a JsxNamespacedName attribute name goes through checkExpression instead of becoming a string literal type (and is compared to non-matching index signatures).
- types.ts `JsxNamespacedName extends PrimaryExpression` (fix changed it to `Node`); needed so the old body type-checks and the node is an "expression" again.
- utilitiesPublic.ts `isLeftHandSideExpressionKind`: re-added `case SyntaxKind.JsxNamespacedName` (hunk removed it).

Final: SUMMARY: 2/49 oracle cases failing (2 fix-added).
