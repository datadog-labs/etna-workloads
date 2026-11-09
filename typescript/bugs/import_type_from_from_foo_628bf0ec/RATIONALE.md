# Rationale
One hunk, tree/src/compiler/parser.ts (parseImportDeclarationOrImportEqualsDeclaration, `type` modifier check).
Corresponds to the second hunk of fix.diff: restored the pre-fix condition `token() !== FromKeyword && identifier?.escapedText === "type" && ...`, removing the
`(token() !== FromKeyword || isIdentifier() && lookAhead(nextTokenIsFromKeyword...))` clause. So `import type from from "foo"` no longer parses `type` as a type-only modifier.
(The first hunk, adding the helper, is not needed: today's helper nextTokenIsFromKeywordOrEqualsToken just becomes unused-by-this-site but is still used elsewhere/compiles.)

Final: SUMMARY: 3/6 oracle cases failing (3 fix-added).
