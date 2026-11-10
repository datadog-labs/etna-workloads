# Rationale
Single hunk in tree/src/compiler/checker.ts (checkBinaryLikeExpression, assignment case).
Corresponds to the only hunk of fix.diff: the fix removed the guard
`&& (!isIdentifier(left) || unescapeLeadingUnderscores(left.escapedText) !== "exports")`.
Re-adding it skips the assignability check when assigning to an identifier named `exports`, so type errors
for assignments to a variable called "exports" are lost (typeCheckExportsVariable errors baseline differs).

SUMMARY: 1/6 oracle cases failing (1 fix-added).
