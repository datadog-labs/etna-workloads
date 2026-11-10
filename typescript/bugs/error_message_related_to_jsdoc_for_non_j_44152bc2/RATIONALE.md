# Rationale
One hunk, `tree/src/compiler/checker.ts` `checkJSDocTypeIsInJsFile`: corresponds to the fix.diff checker.ts hunk.
The fix added a branch giving JSDoc nullable/non-nullable types in TS files the specific
"'?' at the start/end of a type is not valid TypeScript syntax" diagnostics. I removed that branch, so every
JSDoc type in a non-JS file again reports the generic "JSDoc types can only be used inside documentation comments".
The new diagnostic messages, codefix errorCodes and fixJSDocTypes.ts remain but are never triggered (the
codefix still handles error 8020, so only the diagnostic-text change is the symptom).

Final: SUMMARY: 15/65 oracle cases failing (4 fix-added).
