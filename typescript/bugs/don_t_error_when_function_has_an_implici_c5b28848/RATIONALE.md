# Rationale
Hunk (checker.ts, checkAllCodePathsInNonVoidFunctionReturnOrThrowDiagnostics): the strictNullChecks branch
`!isTypeAssignableTo(undefinedType, type)` became `!maybeTypeOfKind(type, Undefined | Void | Any)`.
Corresponds to the fix.diff hunk, which added `Unknown` to the flag-based "return type needs no return" check.
Today's code expresses this via assignability of undefined to the return type; reverting to a flag-only check
again ignores `unknown` (and other types undefined is assignable to), so error 2366 is wrongly reported.
Result: functionsWithImplicitReturnTypeAssignableToUndefined(strictnullchecks=true) errors baseline fails.
Final: SUMMARY: 1/18 oracle cases failing (1 fix-added).
