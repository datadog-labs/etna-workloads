# Rationale
Only hunk changed: `tree/src/services/services.ts` `getMoveToRefactoringFileSuggestions`.
Corresponds to the services.ts hunk of fix.diff: the fix let .ts files be suggested when moving non-JSX content from a .tsx file (and .js from .jsx). The filter is reverted to `extension === fileNameExtension` only, so cross-extension targets are never suggested. The `toMoveContainsJsx` variable and `containsJsx` import (unused afterwards) were removed so the build type-checks.
The moveToFile.ts/moveToNewFile.ts hunks are a refactor (createNewFileName signature, containsJsx helper) that today's code already has in fixed form; not needed to reintroduce the behaviour.

SUMMARY: 2/6 oracle cases failing (2 fix-added).
