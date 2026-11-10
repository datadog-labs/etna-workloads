# Rationale

Bug: REPL tab completion crashes (TypeError reading 'start' of null) on declarations without an initializer, e.g. `let a`, because findExpressionCompleteTarget dereferences `declarations.at(-1).init`, which is null.

Hunk: lib/internal/repl/completion.js (code moved there from lib/repl.js since the fix). Removed the `if (!lastDeclarationInit) return null;` guard added by the fix's lib/repl.js hunk, restoring the pre-fix unguarded dereference.

Failing test: parallel/test-repl-tab-complete ("does not break with variable declarations without an initialization") fails with `TypeError: Cannot read properties of null (reading 'start')`. Stable across two runs.
