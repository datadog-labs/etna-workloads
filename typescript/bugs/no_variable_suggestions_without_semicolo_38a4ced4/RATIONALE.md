# Rationale
Hunk (tree/src/services/completions.ts, `getClosestSymbolDeclaration`, today's name for `getVariableOrParameterDeclaration`):
the fix split the lookup into a parameter/type-parameter search from contextToken plus a variable-declaration search from `location`. I restored the pre-fix behaviour: a single ancestor search from `contextToken` that also matches `isVariableDeclaration`, and removed the `location` fallback. Without a semicolon the contextToken is not inside the variable declaration, so the variable is no longer detected and its own name is suggested/omitted wrongly (completion 'd' missing at marker 2 in completionEntryForConst.ts).
The call-site hunk (passing `location`) is unchanged because the function signature is kept (the `location` parameter is now unused but still type-checks).

Final check.sh: SUMMARY: 1/1 oracle cases failing (0 fix-added).
