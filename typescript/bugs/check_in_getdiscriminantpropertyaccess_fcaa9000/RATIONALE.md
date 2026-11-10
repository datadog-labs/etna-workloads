# Rationale
Hunk: tree/src/compiler/checker.ts, getDiscriminantPropertyAccess (line ~29523).
The fix changed the choice of type used for discriminant detection so the declared union is only used when appropriate (not blindly). In today's code that guard is `isTypeSubsetOf(computedType, declaredType)`; I removed it, so the declared union type is always used when it is a union, even if the computed type isn't a subset (e.g. after type-predicate narrowing). This restores the buggy behaviour.

Final: SUMMARY: 2/6 oracle cases failing (0 fix-added).
