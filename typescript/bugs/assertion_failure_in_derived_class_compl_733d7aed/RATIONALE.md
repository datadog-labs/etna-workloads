Hunk: tree/src/services/codefixes/helpers.ts, getReturnTypeFromSignatures: typeToTypeNode flags changed from NodeBuilderFlags.NoTruncation back to `/*flags*/ undefined` (corresponds to the single hunk of fix.diff; the extra AllowUnresolvedNames argument is today's code). Truncated type nodes then trigger the "Token end is child end" assertion in derived class completion.

SUMMARY: 1/1 oracle cases failing (1 fix-added).
