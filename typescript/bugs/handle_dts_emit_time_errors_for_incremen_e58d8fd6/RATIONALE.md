# Rationale
One hunk in `tree/src/compiler/builder.ts` (emit-result handling in `affected`/`emitNextAffectedFile` flow): removed
`if (result.diagnostics.length) (state.emitDiagnosticsPerFile ??= new Map()).set(affectedSourceFile.resolvedPath, result.diagnostics);`.
Corresponds to the fix.diff hunk `@@ -1550,6 +1594,7 @@` that added this line. Without it, dts-emit-time
errors are never cached in builder state / buildInfo, so incremental and tsbuild runs lose declaration emit errors
(not re-reported, up-to-date checks wrong) - the original bug.

Final: SUMMARY: 7/88 oracle cases failing (1 fix-added).
