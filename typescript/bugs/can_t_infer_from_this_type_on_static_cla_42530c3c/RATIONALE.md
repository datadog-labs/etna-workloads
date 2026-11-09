# Rationale
One hunk in tree/src/compiler/checker.ts, getSignatureFromDeclaration: the fix added an early
`if (isInJSFile(declaration)) { getJSDocThisTag(declaration) ... thisParameter = ... }`. In today's code
that is expressed as `thisTag` being initialised from `getJSDocThisTag(declaration)` for JS declarations
(later consumed by `if (thisTag && thisTag.typeExpression)`). I reverted the initialiser to `undefined`,
so a `@this` tag on the declaration itself is ignored (only tags found as parameters of JSDoc signatures are used).
Result: `this` is not inferred from `@this` on e.g. static methods (inferThis, thisTag1, constructorTagWithThisTag baselines differ).

Final check.sh: SUMMARY: 3/18 oracle cases failing (1 fix-added).
