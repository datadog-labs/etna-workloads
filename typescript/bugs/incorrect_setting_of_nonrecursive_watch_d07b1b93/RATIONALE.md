Hunk 1 (resolutionCache.ts, root case of getDirectoryToWatchFailedLookupLocation, "Always watch root directory non recursively"): `nonRecursive: true` -> `false`. Matches fix.diff hunk 1 (fix changed false -> true).
Hunk 2 (createResolutionCache / watch-at-root path, `if (dirPath === rootPath)`): `Debug.assert(nonRecursive)` -> `Debug.assert(!nonRecursive)`. Matches fix.diff hunk 2 (in today's code the assert lives in the failed-lookup watcher setup).
Result: canWatch baselines report Recursive=false for root-watch rows.
Summary: SUMMARY: 8/92 oracle cases failing (0 fix-added).
