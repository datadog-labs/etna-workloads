# Rationale
One hunk in tree/src/services/refactors/extractSymbol.ts, in `getFirstDeclarationBeforePosition`:
removed the `&& declaration.pos < position` condition. This corresponds to the last hunk of fix.diff
(the `declaration.pos < position` filter). Without it, type parameters declared inside the extraction
range are treated as captured and emitted as type parameters of the extracted function (duplicating
declarations inside the range), which is the original bug. Other hunks of the fix (rename, mapDefined) are
refactoring that are behaviourally inert without the filter, so left as is.

SUMMARY: 2/2 oracle cases failing (2 fix-added).
