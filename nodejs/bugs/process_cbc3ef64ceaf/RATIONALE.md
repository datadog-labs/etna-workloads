# Rationale

**Bug:** destroying process.stdout/stderr (e.g. reading from them, or destroying them) made the stdio streams fail with ERR_STDOUT_CLOSE / ERR_STDERR_CLOSE ("process.stdout cannot be closed") instead of being a harmless no-op, so reading from stdout/stderr sockets broke and the process exited non-zero.

## Hunks
1. `lib/internal/errors.js`: re-adds `ERR_STDERR_CLOSE` and `ERR_STDOUT_CLOSE` (reverse of the fix's errors.js hunk).
2. `lib/internal/bootstrap/switches/is_main_thread.js`: `dummyDestroy` (today's equivalent of the fix's `dummyDestroy`, which replaced the per-stream `_destroy` that raised the errors) again does `err = err || new ERR_STD{OUT,ERR}_CLOSE()` before calling `cb(err)`, restoring the old error-on-close behaviour.

## Failing tests
- parallel/test-stdout-cannot-be-closed-child-process-pipe: `AssertionError: Expected values to be strictly equal: 1 !== 0` (child exits with code 1).
- pseudo-tty/test-stdout-read: fails (output mismatch / error from stderr destroy).
Failure was stable across two runs.
