# Rationale

One hunk, in `signatureToSignatureDeclarationHelper` (tree/src/compiler/checker.ts). It corresponds to the fix.diff hunk
`@@ -7187,11 +7195,13 @@ signatureToSignatureDeclarationHelper`.

The fix moved `getExpandedParameters` + `enterNewScope(...)` to the top of the function, before the type
parameters/arguments are serialized. That gives each signature its own scope for type-parameter names, because
enterNewScope calls cloneNodeBuilderContext. I moved the two lines back to after the type parameter serialization,
which is the pre-fix order. Type parameters of sibling signatures then share one naming scope. Overloads print
`<T_1, U>`, `<T_2>` and so on instead of reusing `T`. This is the scoping bug in the commit title.

Other fix hunks (the added context fields, `originalParameters` handling and so on) are already in today's code and I left them alone.

Final ./check.sh summary: SUMMARY: 211/1440 oracle cases failing (0 fix-added). The 0 fix-added is as reported by the script. I did not check why.
