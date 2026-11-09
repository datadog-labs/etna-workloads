# Rationale
Single file changed: `tree/src/services/codefixes/annotateWithTypeFromJSDoc.ts`.
- Removed `case SyntaxKind.JSDocTypeLiteral` in `transformJSDocType` and the `transformJSDocTypeLiteral` function (fix.diff hunks 3 and 4 of annotateWithTypeFromJSDoc.ts). JSDoc object types (`@param {Object} o` with `@param o.x`) are no longer converted to type literals, so the quick fix hits the visitor default and crashes ("Node JSDocTypeLiteral did not pass test 'isTypeNode'").
- Removed the now-unused imports (`isOptionalJSDocPropertyLikeTag`, `JSDocTypeLiteral`) so the build type-checks. The fix's move of `isOptionalJSDocPropertyLikeTag` from checker to utilities is not reverted: it is already in utilities, and moving it back is unrelated to the behaviour.

check.sh: SUMMARY: 3/3 oracle cases failing (3 fix-added).
