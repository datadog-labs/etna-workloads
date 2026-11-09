# Rationale
Single hunk in `tree/src/compiler/checker.ts` (accessor branch of the property-to-type-element serialization, ~line 7785).
The fix added `!isErrorType(propertyType) && !isErrorType(writeType)` to the accessor check so error-typed accessors are not serialized as get/set signatures. Today's code wraps this in `if (!isErrorType(propertyType) && !isErrorType(writeType)) {`; I replaced it with a bare block `{`, restoring the unguarded behaviour (the crash/incorrect output for accessors with errors in the return statement).

Final: SUMMARY: 2/6 oracle cases failing (2 fix-added).
