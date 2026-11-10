# Re-introduced bug: readline question stack overflow with `signal`

**Bug:** `Interface.prototype.question` with `options.signal` wraps the user callback in a new function assigned back to `cb`. Without saving the original, the wrapper calls `cb` (itself), so answering recurses infinitely: "RangeError: Maximum call stack size exceeded". The user callback is never called.

**Hunk (lib/readline.js, `Interface.prototype.question`)**: corresponds to the fix's single hunk. Removed `const originalCb = cb;` and changed `return originalCb(answer)` back to `return cb(answer)`. (Today's code uses `disposable[SymbolDispose]()` instead of `cleanup()`, otherwise the same.)

**Failing test:** `parallel/test-readline-interface` (the "Calling the question callback with abort signal" and promisified cases): `RangeError: Maximum call stack size exceeded`. `test-readline-promises-interface` still passes (stable across two runs).
