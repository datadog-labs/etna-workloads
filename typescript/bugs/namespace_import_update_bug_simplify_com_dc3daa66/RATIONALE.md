# Rationale
Single file: tree/src/services/refactors/moveToFile.ts (today's home of moveToNewFile code), plus the `getBaseFileName` import it needs.

Hunk: in `updateNamespaceLikeImport`, the final `updateNamespaceLikeImportNode(...)` call now receives `getBaseFileName(newModuleSpecifier)` (the raw module name) instead of `preferredNewNamespaceName`.
Corresponds to the fix.diff hunk in `updateNamespaceLikeImport` that changed the call from `newModuleName` to `preferredNewNamespaceName`. Before the fix, the inserted import's namespace name was the raw module name rather than the computed valid identifier used to rewrite the references. The two disagree, or the name is not a valid identifier.
Other fix hunks (renames, signature plumbing) have no behaviour left to restore in today's code.

check.sh: SUMMARY: 1/1 oracle cases failing (1 fix-added).
