# Rationale
Hunk: `isPatternLiteralPlaceholderType` in tree/src/compiler/checker.ts (corresponds to the single hunk of fix.diff).
The fix added `!isGenericType(type)` so intersections containing generic members are not placeholders (so string mappings/templates over them are deferred). Today's code expresses this by returning false for any intersection member that is neither a placeholder nor an object type (e.g. type parameters). I removed that `else if (!(t.flags & Object)) return false;` branch, so generic members are ignored again, as in the old `some(...)` logic, and `Uppercase<T & string>`-like types are wrongly treated as pattern literals and not deferred.

SUMMARY: 2/6 oracle cases failing (2 fix-added).
