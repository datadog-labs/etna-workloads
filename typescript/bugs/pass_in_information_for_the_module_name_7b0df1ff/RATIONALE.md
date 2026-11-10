# Rationale

One hunk, in `tree/src/compiler/resolutionCache.ts` (`resolveNamesWithLocalCache`, the loop over `entries`), plus two added imports (`getModeForResolutionAtIndex`, `isStringLiteralLike`).

Corresponds to the fix's resolutionCache.ts hunk that made the resolution cache use `resolutionInfo.names` and `getModeForUsageLocation` for string-literal entries instead of calculating the mode from the position in the (possibly partial) names list (`getModeForResolutionAtIndex(containingSourceFile, i)`).
Today's code already passes literals, so the faulty behaviour is restored by computing the mode of module-literal entries from their index in the `entries` list. When resolutions are partially reused, `entries` is only the unknown subset, so the index no longer matches the import's position in the file. That gives the wrong import-attribute resolution mode (issue #48229).

Final check.sh: SUMMARY: 2/149 oracle cases failing (1 fix-added).
