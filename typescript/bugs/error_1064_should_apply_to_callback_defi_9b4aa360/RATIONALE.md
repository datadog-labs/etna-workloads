# Rationale
Single hunk in `tree/src/compiler/checker.ts`, `checkSignatureDeclarationDiagnostics`, matching the first hunk of fix.diff (@@ -38309).
I removed the `isInJSFile(node)` block that looks up the JSDoc `@type` tag, takes its single call signature (e.g. a `@callback` typedef) and uses that signature's return type node and the tag's type reference as the error location. `returnTypeNode` and `returnTypeErrorLocation` are now both just `getEffectiveReturnTypeNode(node)` (changed to const).
Result: async/generator return-type errors (e.g. 1064) are no longer reported for JS functions whose type comes from a `@callback`, as before the fix.
The later hunks of fix.diff (checkAsyncFunctionReturnType, the new 1065 message) are left alone. They are harmless without the lookup, and keeping them is minimal.

Final check.sh: SUMMARY: 4/24 oracle cases failing (2 fix-added).
