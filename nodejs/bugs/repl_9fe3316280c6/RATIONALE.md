# Re-introduced bug: eval error after close throws ERR_USE_AFTER_CLOSE

**Bug:** If a REPL server's custom `eval` calls its callback with an error after the server has been closed, the error handler (`REPLServer.prototype._handleError`-equivalent in lib/repl.js) unconditionally calls `displayPrompt()`. On a closed readline interface this throws `ERR_USE_AFTER_CLOSE`.

**Changes (lib/repl.js, two hunks, both in the error-handling method):**
1. In the `process.nextTick` branch (uncaughtException listeners present): removed the `if (!this.closed)` guard around `this.displayPrompt()`. Corresponds to the fix's first hunk (the code has moved from a `self.on('...')` closure into a class method, using `this`).
2. In the `else` branch (writes `Uncaught ...` to output): removed the `if (!this.closed)` guard around `this.displayPrompt()`. Corresponds to the fix's second hunk.

**Failing test:** `parallel/test-repl-eval-error-after-close` fails (stable across 2 runs) with `Error [ERR_USE_AFTER_CLOSE]: readline was closed` thrown from `displayPrompt`.
