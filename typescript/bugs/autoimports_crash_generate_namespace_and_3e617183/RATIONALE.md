# Rationale
One hunk changed: `tree/src/services/refactors/helpers.ts`, in `addTargetFileImports`. I removed the
`else if (targetSymbol.parent === undefined) { ... importAdder.addImportForModuleSymbol(...) }` branch.
This corresponds to the last hunk of fix.diff (refactors/helpers.ts), which added that branch.
Without it, namespace/module-symbol imports (which have no `parent`) go to `addImportFromExportedSymbol`,
which hits `Debug.checkDefined(exportedSymbol.parent)` and crashes. That is the original "autoimports crash".
The other fix hunks (new `addImportForModuleSymbol`, `ExportKind.Module`) are left in place as unused code, so the build still type-checks.

Final: SUMMARY: 11/18 oracle cases failing (11 fix-added).
