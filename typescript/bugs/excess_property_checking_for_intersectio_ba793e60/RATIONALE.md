# Rationale
One hunk in `tree/src/compiler/checker.ts` (in `recursiveTypeRelatedTo`'s structuredTypeRelatedToWorker, the "target is an intersection" check): removed the
`if (result && isObjectLiteralType(source) && getObjectFlags(source) & ObjectFlags.FreshLiteral) { result &= indexSignaturesRelatedTo(...IntersectionState.None) }` block.
This matches fix.diff hunk 1 (the added indexSignaturesRelatedTo call after propertiesRelatedTo). Without it, fresh object literals assigned to intersections with index signatures
skip the index signature check, so excess/incompatible properties go unreported.
The fix's other hunks (threading intersectionState into membersRelatedToIndexInfo) are plumbing and are left in place; they don't change behaviour without the call.

Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
