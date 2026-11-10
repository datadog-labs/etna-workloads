# Rationale
Both hunks are in tree/src/services/stringCompletions.ts.
1. getStringLiteralCompletionsFromModuleNamesWorker: dropped `&& !compilerOptions.paths` from the rooted-path/URL condition (fix hunk 2). Without baseUrl, paths-only configs are treated as relative completions again.
2. getCompletionEntriesForNonRelativeModules: `paths` completions are nested back inside `if (baseUrl)` (fix hunk 3), so paths without baseUrl yield no completions. The getPathsBasePath import (fix hunk 1) is left in place; it is still used elsewhere in the file, so the build is fine.

Final: SUMMARY: 2/2 oracle cases failing (2 fix-added).
