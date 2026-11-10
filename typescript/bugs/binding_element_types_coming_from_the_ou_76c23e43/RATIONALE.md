# Rationale
One hunk in `tree/src/compiler/checker.ts`, call site in the destructuring path (`getBindingElementTypeFromParentType`'s tuple helper): `getTupleElementTypeOutOfStartCount(type, index, compilerOptions.noUncheckedIndexedAccess ? undefinedType : undefined)` became `(type, index, undefined)`.
This matches the fix.diff hunk, which added the `noUncheckedIndexedAccess` check that unions `undefined` into the rest type for out-of-bounds tuple indices. Without it, destructured elements beyond the tuple's fixed bounds lose `| undefined`, which is the original bug. The indexed-access caller (line ~19279) is untouched.
SUMMARY: 2/6 oracle cases failing (2 fix-added).
