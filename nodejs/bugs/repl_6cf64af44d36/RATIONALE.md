# Bug
REPL tab completion could cause side effects: `findExpressionCompleteTarget` returned a completion
target containing calls, assignments, updates, for-in/of, which were then evaluated (e.g. `incCounter().`
incremented a counter).

# Change (lib/internal/repl/completion.js, where lib/repl.js's code now lives)
- Removed the acorn-walk block (disallowing ForIn/ForOf/CallExpression/AssignmentExpression/UpdateExpression
  and returning null) – corresponds to the first hunk of the fix.
- Final return reverted from `code.slice(lastBodyStatement.start, lastBodyStatement.end)` to `code` –
  corresponds to the second part of the same hunk.

# Failing tests
parallel/test-repl-tab-complete-nosideeffects fails (counter changed / completion results non-empty because
side-effecting expressions are evaluated).
