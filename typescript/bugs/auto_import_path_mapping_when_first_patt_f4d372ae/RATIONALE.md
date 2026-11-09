# Rationale
Single hunk in tree/src/compiler/moduleSpecifiers.ts (tryGetModuleNameFromPaths): corresponds to the only hunk of fix.diff.
The fix changed `return pathIsRelative(matchedStar) ? undefined : key.replace(...)` into an `if (!pathIsRelative) return ...` so the loop continues to later patterns. I restored the early `return ... ? undefined : replaceFirstStar(key, matchedStar)`, so a first matching pattern that yields a relative path aborts the search.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
