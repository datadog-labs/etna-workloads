# Rationale
One hunk, tree/src/services/codefixes/helpers.ts in createSignatureDeclarationFromCallExpression: the `flags` argument passed to getArgumentTypesAndTypeParameters changed from `NodeBuilderFlags.NoTruncation` back to `undefined`. This matches the single hunk in fix.diff. Type nodes for large object literals are truncated again ("..."), which causes the "Token end is child end" Debug Failure in the formatter.

SUMMARY: 2/2 oracle cases failing (2 fix-added).
