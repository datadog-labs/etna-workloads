# Rationale
Both hunks in `tree/src/compiler/checker.ts` (`checkGrammarModifiers`) remove the
`else if (flags & ModifierFlags.Accessor) { grammarErrorOnNode(... "readonly"/"declare", "accessor") }` branches,
matching the two hunks of fix.diff (ReadonlyKeyword and DeclareKeyword cases). `readonly accessor x` and
`declare accessor x` are no longer reported as errors again.

Final: SUMMARY: 2/12 oracle cases failing (0 fix-added).
