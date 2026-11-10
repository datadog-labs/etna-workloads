# Rationale
One hunk in `tree/src/services/completions.ts` (JsxExpression/JsxSpreadAttribute case), corresponding to the single fix.diff hunk.
The fix widened the condition so JSX attribute-name completions are offered after `}` (without needing `>` as the current token) and after an identifier attribute. I restored the old condition: `previousToken` is `}` AND `currentToken` is `>`. So `<div foo={true} [||] />` and `<div foo={true} t[||] >` no longer get JSX identifier completions.

Final check.sh: SUMMARY: 1/1 oracle cases failing (0 fix-added).
