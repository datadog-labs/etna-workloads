Hunk: getDeleteAction in tree/src/services/codefixes/fixUnmatchedParameter.ts now uses `signature` (not `jsDocHost`) for filterJSDocTags — corresponds to the fix.diff getDeleteAction hunk. With `export /** */ const foo = () => ...` the signature is not the JSDoc host, so a second JSDoc gets added.
(Other fix hunks — Info.jsDocHost, getInfo — left intact; today's rename action also uses jsDocHost, which the original fix did not touch, so minimal.)
Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
