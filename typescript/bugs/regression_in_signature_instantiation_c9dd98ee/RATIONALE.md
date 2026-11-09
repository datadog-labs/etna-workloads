# Rationale
Single hunk in `tree/src/compiler/checker.ts`, `createSignatureTypeMapper`: it now uses `signature.typeParameters!` directly instead of `getTypeParametersForMapper(signature)!`. In today's code the fix's expression `sameMap(tps, tp => tp.mapper ? instantiateType(tp, tp.mapper) : tp)` has been extracted into that helper (still used elsewhere). This corresponds to the one hunk of fix.diff and restores the bug: type parameters with a mapper are no longer instantiated before the signature mapper is created.

Final ./check.sh: SUMMARY: 2/12 oracle cases failing (2 fix-added).
