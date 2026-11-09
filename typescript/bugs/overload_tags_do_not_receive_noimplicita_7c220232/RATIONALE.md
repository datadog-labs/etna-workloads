# Rationale
One hunk, in `tree/src/compiler/checker.ts` (getSignaturesOfSymbol, JSDoc overload tag loop):
removed the `if (jsDocSignature.type === undefined && ...) reportImplicitAny(jsDocSignature, anyType);`
call. This corresponds to fix.diff hunk 1 (which added that call). Overload tags again get no
noImplicitAny error for missing return types. The JSDocSignature case in reportImplicitAny
(fix hunk 2) and the diagnostic message (hunk 3) are left in place; they are now never reached.

SUMMARY: 2/14 oracle cases failing (2 fix-added).
