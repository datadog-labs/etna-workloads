# Rationale
Fix introduced `blockedStringType` (distinct from `wildcardType`) for string literals with skip-direct-inference flag, and used it in getInferredType's wildcard check. Re-expressed in today's code (which has since evolved):

1. `checkExpressionWorker` string literal case: returns `wildcardType` instead of `blockedStringType` (fix hunk 3). Wildcard is then not skipped as an inference candidate.
2. `getInferredType`: `if (!inferredType || inferredType === wildcardType)` falls back to the constraint (fix hunk 2 pre-fix state: wildcardType in the check, replacing the constraint), so the string-literal arg completions are derived from the constraint rather than the previous arg's inference.

Hunk 1 (declaration) is left as-is since the type is still used elsewhere in today's code.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
