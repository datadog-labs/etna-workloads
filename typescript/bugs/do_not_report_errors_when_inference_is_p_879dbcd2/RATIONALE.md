# Rationale
All hunks are in tree/src/compiler/checker.ts and mirror the three hunks of fix.diff, removed:
1. Removed the `isInferencePartiallyBlocked` declaration (fix hunk 1).
2. Removed setting it true/false around `runWithoutResolvedSignatureCaching(node, fn)` (fix hunk 2).
3. `reportErrors = !candidatesOutArray` again (fix hunk 3): resolveCall reports errors during partially blocked inference, producing spurious diagnostics.

Final: SUMMARY: 3/3 oracle cases failing (3 fix-added).
