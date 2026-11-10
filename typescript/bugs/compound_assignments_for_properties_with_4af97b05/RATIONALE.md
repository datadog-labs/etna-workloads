# Rationale
Only `checker.ts` `checkAssignmentOperatorWorker` was changed, reverting the fix's hunk at that location: removed the `assigneeType` block (compound assignment on a property access uses the setter/write type) and restored `checkTypeAssignableToAndOptionallyElaborate(valueType, leftType, ...)`. Compound assignments (`x.p += v`) are again checked against the getter (read) type, so properties with a wider setter type give false errors (getterSetterSubtypeAssignment fails).

The other fix hunks (writeOnly parameter plumbing, utilities.ts accessKind) were left alone: the writeOnly parameter is now unused but harmless, and the accessKind hunks are unrelated refactors in the current code.

Final: SUMMARY: 1/84 oracle cases failing (1 fix-added).
