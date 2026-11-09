# Rationale
Single file changed: tree/src/compiler/moduleSpecifiers.ts, tryGetModuleNameAsNodeModule (two edits, both corresponding to the fix's one hunk in tryGetModuleNameAsNodeModule).
- `if (getResolvePackageJsonExports(options))` -> restored the old Node16/NodeNext-only check, so bundler resolution ignores package.json `exports` when generating specifiers.
- `getConditions(options, importMode)` -> restored hardcoded `["node", import|require, "types"]`, ignoring customConditions.
The fix's other hunks (exporting getConditions, imports) are not needed: getConditions is still used elsewhere in the file.
Result: autoImportBundlerExports and autoImportsCustomConditions both fail (got 'dep/dist', expected 'dep').

SUMMARY: 2/2 oracle cases failing (2 fix-added).
