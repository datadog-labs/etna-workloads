Hunk 1 (checker.ts, removeOptionalityFromDeclaredType + parameterInitializerContainsUndefined): matches fix.diff's main hunk in reverse. Removed the cached helper and restored the old inline logic: pushTypeResolution(declaration.symbol, DeclaredType), checkExpression(initializer) uncached, circularity error if re-entered. This brings back the spurious circularity and the lack of caching.
The enum member and NodeLinks field from fix.diff's other hunks are left in place (now unused, harmless; the build passes).

Final check.sh: SUMMARY: 1/2 oracle cases failing (0 fix-added).
