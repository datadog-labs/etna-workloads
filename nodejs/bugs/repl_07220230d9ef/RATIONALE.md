# Rationale

**Bug:** REPL tab completion failed for expressions with computed string properties, e.g. `obj["one"].toFi` or `obj["inner object"].th`. The old `simpleExpressionRE` did not allow bracketed quoted strings (or spaces inside them), so the completion target was truncated (`["one"].toFi`, `object"].th`) and nothing was completed.

**Change (lib/internal/repl/completion.js):** The fix changed `simpleExpressionRE` in lib/repl.js. That code has since moved to an AST-based `findExpressionCompleteTarget` in lib/internal/repl/completion.js, so the plain reversal does not apply.
1. Re-added `simpleExpressionRE` with the pre-fix pattern (the fix hunk, reversed).
2. The completion target is now the match of `simpleExpressionRE` against the target found by `findExpressionCompleteTarget`, as the old code matched it against the line. This restores the old truncation for computed string properties.

**Failing test:** parallel/test-repl-tab-complete-computed-props fails (`not ok`) in two consecutive runs. Its string-property cases get wrong completions, for example `obj["one"].toFi`.
