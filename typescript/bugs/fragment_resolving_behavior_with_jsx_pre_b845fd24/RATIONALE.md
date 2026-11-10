All changes in tree/src/compiler/checker.ts.
1. markJsxAliasReferenced main resolveName (fix hunk 1): flags now always SymbolFlags.Value (no `& ~Enum` for preserve), as before the fix.
2. markJsxAliasReferenced fragment pragma resolveName (hunk 2): same.
3. checkJsxOpeningLikeElement/fragment return (hunk 3): `return getJsxElementTypeAt(node) || anyType;` — errorType is truthy so it leaks instead of becoming any.
4. getJSXFragmentType (hunk 4): removed the `jsxFragmentFactoryName !== "null"` early-out and the Enum-exclusion flags, so a null fragment factory is resolved as a name.
Final: SUMMARY: 4/24 oracle cases failing (0 fix-added).
