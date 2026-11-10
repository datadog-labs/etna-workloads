# Rationale
Hunk: tree/src/services/inlayHints.ts, in the argument loop of visitCallOrNewExpression. I removed `signatureParamPos++;` before `continue` in the `shouldShowLiteralParameterNameHintsOnly && !isHintableLiteral` branch.
This matches the fix.diff hunk that added that line. (The fix's other change only moved a declaration, so it has no effect on behaviour.)
Without the increment, skipped non-literal args don't advance the parameter index, so later literal args get the wrong parameter name hint.
Final check.sh: SUMMARY: 1/1 oracle cases failing (0 fix-added).
