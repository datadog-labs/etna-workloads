# Bug
AssertionError ignores the legacy `stackStartFunction` option (only `stackStartFn` is honored), so frames of the function passed via the old option are not hidden from the stack.

# Changes (lib/internal/assert/assertion_error.js)
- Hunk 1 (fix hunk 1): removed `stackStartFunction` from the options destructuring (and its compat comment).
- Hunk 2 (fix hunk 2): `ErrorCaptureStackTrace(this, stackStartFn || stackStartFunction)` -> `ErrorCaptureStackTrace(this, stackStartFn)`.

# Failing test
parallel/test-assert: "not ok" (the added check `assert(!err.stack.includes('hidden'))` fails for the `stackStartFunction` case), stable over two runs.
