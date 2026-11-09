Hunk: tree/src/compiler/checker.ts, `getResolvedSignatureForSignatureHelp` no longer wraps the call in `runWithoutResolvedSignatureCaching(node, ...)`.
Corresponds to the fix.diff hunk that added `runWithoutResolvedSignatureCaching` around signature help. Without it, signature help caches its resolved signature (with the wrong arity) on the call node, so later diagnostics miss the arity error.
Final check.sh: SUMMARY: 1/2 oracle cases failing (1 fix-added)
