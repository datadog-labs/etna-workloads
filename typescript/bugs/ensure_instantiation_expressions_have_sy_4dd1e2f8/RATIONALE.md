# Rationale
One hunk, tree/src/compiler/checker.ts (getInstantiationExpressionType): the result type is created with `createAnonymousType(/*symbol*/ undefined, ...)` instead of a fresh `__instantiationExpression` symbol. This reverses the fix.diff hunk at ~35677. Instantiating that symbol-less anonymous type later trips the existing `Debug.assert(type.symbol, ...)` in instantiateAnonymousType (the crash the fix prevented).
Other fix hunks (types.ts enum member, serializer move, asserts) were left as-is: they are harmless/unused without this hunk, or already present.

SUMMARY: 12/43 oracle cases failing (12 fix-added).
