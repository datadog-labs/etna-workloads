# Rationale
Hunk: checker.ts `createAnonymousTypeNode`, InstantiationExpressionType branch. The fix added a circularity guard (`context.visitedTypes?.has(typeId)` -> elided placeholder, else `visitAndTransformType`) for instantiation-expression types. In today's code the branch moved into the `if (symbol)` block; I removed the guard and call `createTypeNodeFromObjectType(type)` directly (pre-fix behaviour: no cycle detection), giving infinite recursion / stack overflow on circular instantiation expressions.

Final: SUMMARY: 2/31 oracle cases failing (2 fix-added).
