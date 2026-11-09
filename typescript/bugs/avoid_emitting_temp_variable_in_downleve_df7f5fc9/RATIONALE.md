# Rationale
All changes are in `tree/src/compiler/transformers/module/module.ts`, `createImportCallExpressionCommonJS`. They reverse the single fix.diff hunk group (the fix's only file):
- `needSyncEval` -> `temp` (hoisted temp variable) again: fix hunk 1 replaced the temp var declaration.
- `Promise.resolve(...)` args back to `[]` (fix removed template/concat arg).
- `require(s)` -> `require(temp)`; removed the `s` parameter list (`parameters` -> `[]`) in arrow/function expressions.
- Return comma-list `(temp = arg, Promise.resolve().then(() => require(temp)))` again instead of the inline form.
Effect: downleveled import() emits `var _a;` hoisted temp variable again.

Final: SUMMARY: 11/66 oracle cases failing (0 fix-added).
