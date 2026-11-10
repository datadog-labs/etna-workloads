# Rationale
One hunk in tree/src/compiler/checker.ts (JSX spread attribute in createJsxAttributesTypeFromAttributesProperty):
`checkExpression(attributeDecl.expression, checkMode & CheckMode.Inferential)` -> `checkExpressionCached(attributeDecl.expression, checkMode)`.
This corresponds to the single fix.diff hunk, which replaced checkExpressionCached(..., checkMode) with checkExpression. Re-adding the cached check makes the spread expression's type get cached during inference, so a generic spread expression isn't re-checked, giving wrong types/errors.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
