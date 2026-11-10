# Rationale
One hunk, in `tree/src/compiler/moduleNameResolver.ts` (`nodeModuleNameResolverWorker`).

It corresponds to the fix.diff hunk `@@ -1403,13 +1419,26 @@` (`nodeModuleNameResolverWorker`). That hunk added a priority split for `ModuleResolutionKind.NodeJs`: it first tries TypeScript|Declaration extensions, then falls back to the remaining ones (JS/JSON). I replaced today's equivalent `Node10` branch with a single `tryResolve(extensions, state)` call over all extensions. This is the behaviour the fix removed: Node10 lookup priorities are no longer enforced, so JS or JSON candidates are probed in the same pass as TS and d.ts candidates, and the lookup order and traces change.

Only the resolver-priority hunks are touched. The Extensions refactor hunks have no counterpart that could be reverted in today's code.

Final ./check.sh summary line: `SUMMARY: 19/899 oracle cases failing (0 fix-added).`
