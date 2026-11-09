# Rationale
One hunk, `tree/src/services/symbolDisplay.ts`: in the recursive call to `getSymbolDisplayPartsDocumentationAndSymbolKindWorker` (alias resolution), `type` is replaced by `/*type*/ undefined`.
This matches the fix.diff hunk that added passing `type` to the Worker in the recursive call. Without it, the resolved symbol's type is recomputed without narrowing, so quick info for aliased symbols in narrowed locations shows the declared type (`string | undefined`) instead of the narrowed one (`string`).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
