# Rationale
1. `src/services/formatting/formatting.ts` (fix hunk: `child.kind !== JsxText && !isGrammarError(parent, child)` in formatting): today's code has `nodeIsMissing(child) || isGrammarError(parent, child)` in processChildNode; removed the `isGrammarError` check (and its now-unused import). Grammar-error children (e.g. initializer on a PropertySignature) are formatted again, so "Token end is child end" assertion fails (the extract-type crash).
2. `src/services/codefixes/generateAccessors.ts` (fix hunk: removing grammar errors from the updated PropertyAssignment): restored the plain `const assignment = factory.updatePropertyAssignment(...)`, dropping the modifiers/questionToken/exclamationToken clearing and the unused `Mutable` import.

Final: SUMMARY: 3/3 oracle cases failing (3 fix-added).
