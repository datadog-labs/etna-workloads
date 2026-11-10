# Rationale
One hunk, in `src/compiler/scanner.ts` (`scanNumber`, legacy octal branch): I removed the `error(Diagnostics.Octal_literals_are_not_allowed_Use_the_syntax_0, ...)` call and the `withMinus`/`literal` computation that fed it.

This corresponds to the fix.diff scanner hunks that moved octal-literal reporting into the scanner. It also corresponds to the removal of `checkGrammarNumericLiteral`'s octal diagnostics from the checker. Without the error, legacy octal literals such as `01` are no longer reported, and the diagnostics the fix added (`Octal_literals_are_not_allowed_Use_the_syntax_0`) no longer appear. This brings back the pre-fix state where the octal-literal error was missing in these contexts.

This is a partial re-expression. I did not touch the escape-sequence or template-literal parts of the fix.

Final check.sh summary: SUMMARY: 22/253 oracle cases failing (3 fix-added).
