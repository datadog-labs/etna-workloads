# Rationale
Both edits are in tree/src/compiler/checker.ts and undo the fix's "ignoreErrors => no errorNode" plumbing.

1. `resolveExternalModuleNameWorker`: passes `moduleReferenceExpression` as errorNode unconditionally instead of `!ignoreErrors ? moduleReferenceExpression : undefined`. Matches fix.diff hunk changing the worker's call to resolveExternalModule. So getSymbolAtLocation (ignoreErrors=true) once again reports module-resolution errors.
2. `resolutionDiagnostic` in `resolveExternalModule`: removed the `errorNode &&` guard (fix hunk "const resolutionDiagnostic = errorNode && ..."), so resolution diagnostics are computed/reported even when errors should be ignored.

Result: getSymbolAtLocation on synthetic jsx import crashes ("start < 0") and incremental baselines differ.

Final: SUMMARY: 3/98 oracle cases failing (2 fix-added).
