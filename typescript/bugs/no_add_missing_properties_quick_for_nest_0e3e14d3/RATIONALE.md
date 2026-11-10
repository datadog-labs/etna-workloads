# Rationale
One hunk in `tree/src/services/codefixes/fixAddMissingMember.ts` (getInfo, object-literal-initializer branch).
Corresponds to the single hunk of fix.diff: the fix added `checker.getContextualType(token) || ...` as the target type.
Today's code is `(getContextualType(token) || getTypeAtLocation(token))?.getNonNullableType()`; I removed the contextual-type lookup, leaving `getTypeAtLocation(token)?.getNonNullableType()`.
For a nested object literal the token's own type isn't the expected type, so no missing properties are found and the quick fix is not offered (codeFixAddMissingProperties28 fails: "Should find at least 1 codefix").
SUMMARY: 1/1 oracle cases failing (1 fix-added). Local baselines (actual output) are in <workdir>/tree/tests/baselines/local/
