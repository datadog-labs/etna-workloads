# Rationale
One hunk in `tree/src/compiler/checker.ts` (evaluator's `isConstantVariable(symbol)` branch, ~line 47991) corresponds to the single hunk of fix.diff.
The fix replaced a blind cast `symbol.valueDeclaration as VariableDeclaration | undefined` with an `isVariableDeclaration(declaration)` guard. I restored the cast and removed the guard, so a const binding element with an initializer (e.g. `const {a = 1} = ...`) is treated as a variable declaration and its initializer is used as the constant value.

Final check.sh: SUMMARY: 4/12 oracle cases failing (4 fix-added).
