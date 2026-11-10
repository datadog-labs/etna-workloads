# Rationale
Single hunk: `tree/src/compiler/utilities.ts` `getSynthesizedDeepClone` (the function moved from services/utilities.ts since the fix). Matches the fix.diff hunk: `return setParentRecursive(clone, false)` -> `return clone`. Without parent pointers on the cloned nodes, code fixes/extract (JSX props with dashes, etc.) hit errors in formatting and produce wrong output. The unused import hunk is not needed (compiler/utilities.ts defines the function itself).

Final: SUMMARY: 3/122 oracle cases failing (2 fix-added).
