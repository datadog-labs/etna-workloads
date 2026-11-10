# Rationale
Hunk 1 (checker.ts, checkSingleIdentifier): fix.diff added `isExpressionNodeOrShorthandPropertyAssignmentName` and used it plus `getResolvedSymbol` in checkSingleIdentifier. Reverted to the old `isExpressionNode(node)` and `getSymbolAtLocation(node, true)`; helper removed. Shorthand property names in loops are no longer flagged as captured, so the ES5 loop emit is wrong.
Hunk 2 (utilities.ts): comment-only in the fix; nothing to revert.

SUMMARY: 1/12 oracle cases failing (1 fix-added).
