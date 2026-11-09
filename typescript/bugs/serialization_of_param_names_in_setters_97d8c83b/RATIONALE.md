# Rationale
One hunk, in `tree/src/compiler/checker.ts` (accessor serialization in `serializeAsClass` / property member serialization):
the setter parameter name passed to `factory.createParameterDeclaration` is changed from
`paramSymbol ? parameterToParameterDeclarationName(paramSymbol, getEffectiveParameterDeclaration(paramSymbol), context) : "value"`
back to the literal `"arg"`. This corresponds to the last hunk of fix.diff (which replaced `"arg"` with the real parameter name).
The helper functions from the other hunks were kept (they are still used elsewhere/refactor only); the setter-lookup code still feeds the approximateLength.
Effect: declaration emit for setters from JS files always names the parameter `arg`.

SUMMARY: 12/72 oracle cases failing (3 fix-added).
