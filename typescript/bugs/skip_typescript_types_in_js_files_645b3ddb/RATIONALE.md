Changes in tree/src/services/codefixes/helpers.ts (createSignatureDeclarationFromSignature), reverting the fix's hunks:
- `typeParameters = isJs ? undefined : ...` -> `signatureDeclaration.typeParameters` (fix hunk 2): JS files get type parameters again.
- `type = isJs ? undefined : ...` -> `getSynthesizedDeepClone(signatureDeclaration.type)` (fix hunk 2): JS files get return types again.
- parameter `type = isJs ? undefined : parameterDecl.type` -> `parameterDecl.type` (fix hunk 3): JS files get parameter types again.
The `isJs` const stays (still used for questionToken, pre-existing).
Result: TS types are emitted in JS files (codeFixAddMissingProperties25 fails with `f: function(x: string): number`).
SUMMARY: 1/1 oracle cases failing (1 fix-added).
