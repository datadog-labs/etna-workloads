# Rationale
One hunk in `tree/src/compiler/checker.ts` (checkPropertyAccessExpressionOrQualifiedName): corresponds to fix.diff hunk @@ -31550. The fix resolved the aliased property symbol (`resolveAliasWithDeprecationCheck(prop, right)`) before the deprecation check. I restored the old code that checks `prop` directly, so deprecated re-exports (`export { /** @deprecated */ a }`) accessed via `ns.a` no longer get the deprecation suggestion.

SUMMARY: 1/2 oracle cases failing (1 fix-added) (jsdocDeprecated_suggestion21 fails; suggestion20 still passes).
