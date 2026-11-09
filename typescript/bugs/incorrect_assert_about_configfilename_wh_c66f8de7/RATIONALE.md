# Rationale
Both hunks are in tree/src/compiler/watchPublic.ts and mirror the two hunks of fix.diff.
1. Re-added `Debug.assert(configFileName);` at the top of `updateExtendedConfigFilesWatches` (fix hunk 1 removed it). It fires wrongly when a watch is created with explicit options/projectReferences and no config file.
2. In the extended-config watcher callback, `if (configFileName && toPath(configFileName) === projectPath)` became `if (toPath(configFileName) === projectPath)` (fix hunk 2). The assert from hunk 1 narrows the type, so the code still type-checks.

Final: SUMMARY: 2/24 oracle cases failing (2 fix-added).
