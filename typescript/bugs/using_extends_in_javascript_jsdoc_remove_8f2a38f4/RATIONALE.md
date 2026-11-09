All changes in tree/src/compiler/utilities.ts (CRLF preserved).

1. isExpressionNode, case ExpressionWithTypeArguments: removed `&& !isJSDocAugmentsTag(node.parent)` — reverses fix hunk 2 exactly.
2. tryGetClassImplementingOrExtendingExpressionWithTypeArguments: restored the heritage-clause-only form, dropping the @augments/getEffectiveJSDocHost branch — reverses fix hunk 3 exactly.
3. isPartOfTypeExpressionWithTypeArguments: removed `|| isJSDocAugmentsTag(node.parent)`. Not a literal fix hunk: in today's code the "@extends base is not an expression/is a type" classification lives here (isPartOfTypeNode is checked before isExpressionNode in getTypeOfNode), so this is the modern expression of fix hunk 2's behaviour. Without it the @extends base node is no longer treated as a type, getTypeAtLocation on it misbehaves, and inherited method documentation is lost (the #50117 symptom; baseline loses "Method documentation.").

Hunks 1 and 2 alone do not fail any oracle case; hunk 3 is what triggers the failure.

SUMMARY: 2/2 oracle cases failing (2 fix-added).
