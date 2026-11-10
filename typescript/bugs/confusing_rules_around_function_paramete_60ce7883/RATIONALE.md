# Rationale
One hunk, `tree/src/checker.ts` `checkVariableLikeDeclaration` (src/compiler/checker.ts ~45129).
The fix replaced `isParameter(node) && node.initializer` with `node.initializer && isParameterDeclaration(node)`
(today: `isPartOfParameterDeclaration`), so parameters inside function *types* with initializers are also
reported (binding-element defaults in parameter patterns). Reverting to `isParameter(node) && node.initializer`
restores the bug: the error for those cases is no longer reported, so defaultValueInFunctionTypes errors baseline differs.

Final check.sh: SUMMARY: 1/6 oracle cases failing (0 fix-added).
