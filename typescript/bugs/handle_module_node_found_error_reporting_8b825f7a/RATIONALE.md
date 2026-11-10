Hunk: src/compiler/moduleNameResolver.ts, nodeModuleNameResolverWorker, first diagnosticState (Exports disabled).
Corresponds to fix.diff hunk `@@ -1758,8 +1758,6 @@` which removed `failedLookupLocations: []` and `affectingLocations: []`.
Re-adding them makes the alternate-result lookup record its failed lookup/affecting locations into throwaway arrays,
so they are not reported on the resolution and watch/tsserver don't watch those files (baselines differ).
Only the first (Exports-disabled) state had them in the original; the bundler-fallback state is unchanged.
SUMMARY: 2/142 oracle cases failing (0 fix-added). Local baselines (actual output) are in <workdir>/tree/tests/baselines/local/
