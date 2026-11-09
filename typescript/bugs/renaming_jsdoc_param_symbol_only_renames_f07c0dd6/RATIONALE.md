# Rationale
All hunks are in src/services/findAllReferences.ts and mirror fix.diff:
- Removed the `isJSDocPropertyLikeTag(parent) && parent.isNameFirst && ... jsDocPropertyTags` early-return block in getReferencesAtLocation (fix hunk @@ -1928). Without it, renaming a JSDoc @param symbol with nested property tags only renames the first instance.
- Removed `getReferencesAtJSDocTypeLiteral` (fix hunk @@ -1963).
- Removed the imports the fix added (forEach, isJSDocPropertyLikeTag, isJSDocTypeLiteral, JSDocPropertyLikeTag, length), now unused.
Result: build ok; `SUMMARY: 1/1 oracle cases failing (1 fix-added)` (renameJsDocTypeLiteral).
