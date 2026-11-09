# Rationale

## Hunk: `tree/src/services/codefixes/importFixes.ts`, `addImportFromExportedSymbol`
Removed the block that, when `referenceImport` (the import in the original file) is type-only
and the fix allows it, forces `addAsTypeOnly = AddAsTypeOnly.Required`.

Corresponds to the single hunk of `fix.diff` (`moveToNewFile.ts` `filterImport`), which changed
`factory.createImportClause(/*isTypeOnly*/ false, ...)` to `createImportClause(clause.isTypeOnly, ...)`,
i.e. copied the type-only status of the original import clause into the import generated in the
new file. In v6.0.3 the "move to new file" refactor (now `moveToFile.ts`) no longer builds the new
file's imports with `filterImport`; it passes each needed symbol plus the original import
declaration (`referenceImport`) to the ImportAdder, and this block is where the type-only status of
the original import is copied. Dropping it makes the new import always non-type-only (as the old
hard-coded `false`), so `import type { A }` / `import { type A }` in the source file becomes
`import { A } from "./a"` in the new file, exactly bug #52852.

(The literal location, `filterImport`'s `clause.phaseModifier`, was left unchanged: in today's code it
only rewrites imports in other files and is not on the path that loses `import type`; changing it
did not reproduce the bug, see NOTES.md.)

## Final ./check.sh summary
SUMMARY: 2/2 oracle cases failing (2 fix-added).
