Changed only tree/src/services/importTracker.ts, in `findModuleReferences`:
- fix.diff hunk 3 (forEachImport callback emitting `implicit` refs for synthesized import decls): reverted to always push `{kind:"import"}`; `importDecl` renamed `_importDecl` and the `nodeIsSynthesized` import removed (fix hunk 1) to satisfy unused checks.
  Synthetic jsx-runtime/tslib imports are then treated as real imports, so find-all-references reads positions from synthesized nodes -> "Node must have a real position" crash (the original bug).
- The `implicit` union member and the findAllReferences.ts branch are left in place; they become unreachable, which keeps the diff minimal.

SUMMARY: 2/2 oracle cases failing (2 fix-added).
