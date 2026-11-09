# Rationale
One hunk, in `tree/src/compiler/transformers/utilities.ts` (`collectExternalModuleInfo`): removed
`hasImportDefault ||= containsDefaultReference(exportClause)` for named exports. This is the third hunk of fix.diff
(the added line). Without it, `export { default } from "x"` doesn't set hasImportDefault, so with importHelpers +
esModuleInterop the `__importDefault` helper import is not emitted (the original bug). The helper-function hunks
of the fix are kept (harmless without the call; the type-only changes are not behaviour).

Final: SUMMARY: 18/108 oracle cases failing (2 fix-added).
