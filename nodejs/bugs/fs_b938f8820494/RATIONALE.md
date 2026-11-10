# Bug
`Dir.close()` on an already-closed directory threw ERR_DIR_CLOSED synchronously, instead of passing it to the callback (via nextTick) or returning a rejected promise.

# Change (lib/internal/fs/dir.js, single hunk)
Corresponds to the fix's `close()` hunk: the closed check is moved back to the top of `close()` and throws synchronously for both the callback and promise forms. The `PromiseReject` branch and the `process.nextTick(callback, ...)` branch are removed, along with the now-unused `PromiseReject` primordial import (the fix's import hunk). The code uses `#closed` and `validateFunction`, as in today's release.

# Failing test
parallel/test-fs-opendir fails (stable across 2 runs): `dir.close()` after closing throws synchronously, so `assert.rejects` and the callback-error checks do not get the async error.
