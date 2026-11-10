# Rationale
Hunk: checker.ts `checkImportType` no longer calls `checkTypeReferenceOrImport(node)`.
Corresponds to fix.diff's hunk in the import-type symbol resolution that added the lazy
`checkTypeArgumentConstraints` call for import types (today this logic lives in checkTypeReferenceOrImport, shared with type references).
Without it, `import("x").T<Bad>` type arguments are never constraint-checked, as before the fix.
(The other fix hunks were refactors/type widenings, not behaviour.)

SUMMARY: 2/12 oracle cases failing (2 fix-added).
