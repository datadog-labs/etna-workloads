Hunk: tree/src/compiler/checker.ts (addPropertyToElementList), `if (signatures.length || !optionalToken) return;` -> `if (true) return;`.
Corresponds to the fix's added early-return guard. Pre-fix, function/method properties always stopped after emitting method signatures, so an optional property with no call signatures (undefined from other array elements) never fell through to emit a property signature and was dropped from declaration emit.
SUMMARY: 2/6 oracle cases failing (2 fix-added).
