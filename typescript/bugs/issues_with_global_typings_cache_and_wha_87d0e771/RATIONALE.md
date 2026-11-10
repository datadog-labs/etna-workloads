# Rationale
Two hunks in `tree/src/compiler/moduleNameResolver.ts`, both from the fix's changes to that file:
1. `loadModuleFromNearestNodeModulesDirectoryWorker.lookup`: the fix switched `forEachAncestorDirectory` to `forEachAncestorDirectoryStoppingAtGlobalCache`. I reverted it to plain `forEachAncestorDirectory`, so the node_modules walk goes past the global typings cache location.
2. `classicNameResolver`: same switch in the fix, same revert here.

The helper is still used elsewhere, so the build passes. Resolution from the global cache now climbs above it, which changes the lookup locations that get watched. That's the symptom in the fix-added tsserver resolutionCache baselines.

check.sh: SUMMARY: 2/366 oracle cases failing (2 fix-added).
