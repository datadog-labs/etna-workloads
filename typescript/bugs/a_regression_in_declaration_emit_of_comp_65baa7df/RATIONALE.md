# Rationale
fix.diff hunk (checker.ts): added `if (!hasDynamicName(node)) return visitEachChild(...)` so non-dynamic computed names are preserved in declaration emit; before, they were dropped (`return undefined`) unless the AllowUnresolvedNames condition held (which included `hasDynamicName(node)`).

Today this logic lives in expressionToTypeNode.ts / checker.ts's shouldRemoveDeclaration:
- expressionToTypeNode.ts: removed the `!hasDynamicName(node)` early return (+ cast to DynamicNamedDeclaration, import tweaks so it type-checks).
- checker.ts `shouldRemoveDeclaration`: re-added `hasDynamicName(node) &&` into the AllowUnresolvedNames condition (the pre-fix form), so non-dynamic computed names are removed.

Result: `./check.sh` -> SUMMARY: 2/6 oracle cases failing (2 fix-added).
