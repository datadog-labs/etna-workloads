# Rationale
One hunk in `tree/src/compiler/checker.ts` (isBlockScopedNameDeclaredBeforeUse, parameter-property branch) corresponds to
fix.diff hunk "@@ -2785": the fix replaced `getEmitScriptTarget === ESNext && useDefineForClassFields` with `emitStandardClassFields`
(ES2022+). Restoring the ESNext-only check means the use-before-init error for `foo = this.bar` (bar a parameter property) is
missed under target ES2022.

Final: SUMMARY: 2/54 oracle cases failing (1 fix-added).
