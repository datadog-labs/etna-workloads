# Rationale
Single file: tree/src/compiler/checker.ts, `runWithoutResolvedSignatureCaching`.
The fix added caching/clearing/restoring of `symbolLinks.type` for function-like ancestors (the `cachedTypes` array, the clearing block and the restore loop), so a function's type computed during a completion request isn't reused. I removed those three pieces (today's code uses function expression/arrow ancestors); only resolvedSignature is cleared, so stale function types from the completion request persist and later errors are not reported.
Result: SUMMARY: 1/1 oracle cases failing (1 fix-added).
