# Rationale

**Bug:** REPL tab completion under unary expressions (`delete x.y`, `typeof x`, `void x`, `!x`, ...) did not
extract the operand as the completion target; the whole expression (e.g. `delete globalThis._`) was used,
so completion/eval misbehaved (e.g. "globalThis is not defined" after the delete flow).

**Change:** the fix's single hunk in `lib/repl.js` now lives in `lib/internal/repl/completion.js`
(`findExpressionCompleteTarget`). I removed the block handling `ExpressionStatement` whose expression is a
`UnaryExpression` (recursing on the argument's source). This restores the pre-fix behaviour: such input falls
through to the generic path and the full code is the target.

**Failing test:** `parallel/test-repl-tab-complete-unary-expressions` (`not ok`), e.g.
`actual: 'delete globalThis._', expected: 'globalThis._'`; likewise for `typeof`, `void`, `!`.
Failure was stable across two runs.
