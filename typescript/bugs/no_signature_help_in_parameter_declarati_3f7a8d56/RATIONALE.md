# Rationale
All changes are in `tree/src/services/signatureHelp.ts`, reversing the fix's hunks to `tryGetParameterInfo`, `getAdjustedNode` and `getContextualSignatureLocationInfo`.
- `tryGetParameterInfo`: it no longer calls `getAdjustedNode`. It passes `startingToken` straight to `getContextualSignatureLocationInfo`. This corresponds to the fix's hunk replacing the direct call.
- `getAdjustedNode` is removed. This is the fix's added function that let a token inside a parameter or binding pattern resolve to the parameter.
- `getContextualSignatureLocationInfo`: the early return is restored when the token is not `(` or `,`. As a result, there is no signature help when the cursor sits in a parameter declaration before `,` or `)`.

The fix's import additions are left in place, because unused imports don't break the build.

Final check.sh summary: SUMMARY: 1/1 oracle cases failing (1 fix-added).
