# Re-introduced bug: REPL autocomplete wrong on literals (#41690)

**Bug:** Tab completion on expressions starting with a literal (``` ``.a ```, `''.a`, `"".a`, `("").a`, `[].a`) ignored the literal and completed only the trailing identifier (`a`) against globals, instead of completing members of the literal (`''.at`). The fix widened `simpleExpressionRE` to accept literal/bracket-start expressions.

**Change (one hunk, lib/internal/repl/completion.js):** `simpleExpressionRE` no longer exists; the code is now AST based (`findExpressionCompleteTarget`). The fix's regex hunk corresponds to the final `return` of that function, which returned the whole last statement. I now run the pre-fix regex (identifier-chain only, `/(?:[a-zA-Z_$](?:\w|\$)*\??\.)*[a-zA-Z_$](?:\w|\$)*\??\.?$/`) on that text and return only the match, restoring the old behaviour where only the identifier suffix is the completion target.

**Failing test:** parallel/test-repl-tab-complete, subtest 'works on literals':
`AssertionError: Expected values to be strictly equal: false !== true` (test-repl-tab-complete.js:120). Failure stable across two runs.
