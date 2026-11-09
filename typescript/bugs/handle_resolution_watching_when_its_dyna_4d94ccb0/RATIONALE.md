All hunks in src/compiler/resolutionCache.ts, reversing fix.diff hunks:
1. resolveNamesWithLocalCache: dropped `&& !skipWatchingFailedLookups?.(path)` (fix hunk 2), so dynamic files' failed lookups get watched again.
2. Unused-name cleanup: unconditional stopWatchFailedLookupLocationOfResolution (fix hunk 3), so ref counts are decremented for resolutions never watched.
3. removeResolutionsOfFile: unconditional stop watching (fix hunk 4), same ref-count mismatch.
4. type roots watch: removed the `!isRootWatchable || skipWatchingTypeRoots()` early-close block (fix hunk 5).
Not changed: interface members (hunk 1) and project.ts hunks, since harness code depends on them / build must pass.
Final: SUMMARY: 15/295 oracle cases failing (1 fix-added).
