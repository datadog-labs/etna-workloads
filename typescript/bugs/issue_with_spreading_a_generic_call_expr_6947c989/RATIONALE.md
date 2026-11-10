# Rationale
Two hunks in tree/src/compiler/checker.ts:
1. checkObjectLiteral spread assignment: `checkExpression(memberDecl.expression)` — matches fix hunk 3; the spread expression no longer gets the Inferential check mode, so intra-expression inference sites in spreads are lost.
2. createJsxAttributesTypeFromAttributesProperty spread attribute: `checkExpressionCached(attributeDecl.expression, checkMode)` — matches fix hunk 6; the spread is cached/checked with the wrong mode, so spreading a generic call into generic JSX breaks.
The fix's signature/default-param hunks were left untouched (no behavioural effect in today's code).

Final: SUMMARY: 3/12 oracle cases failing (1 fix-added).
