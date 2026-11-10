# Rationale

**Bug:** fs/promises functions rejected with errors created in C++ from a libuv callback, so they had no JS frames, i.e. no useful stack trace (`Error: ENOENT...` with nothing else). The fix wraps the binding promise with `PromisePrototypeThen(..., undefined, handleErrorFromBinding)`, which re-captures the stack with `ErrorCaptureStackTrace`.

**Change (lib/internal/fs/promises.js, `access`):** corresponds to the fix's `access` hunk. The wrapped `return await PromisePrototypeThen(binding.access(...), undefined, handleErrorFromBinding)` is reverted to the old `return binding.access(getValidatedPath(path), mode, kUsePromises);`. Rejections from `fsPromises.access` therefore again lack the async stack frames. I left the other functions untouched, so the regression is limited to `access`; that is the function the oracle tests exercise.

**Failing tests:** `parallel/test-fs-promises` (stack expected `/at async assert\.rejects/`, got `"Error: ENOENT: no such file or directory, access '...'"` with no frames) and `parallel/test-fs-access` (the `/at async Object\.access/` check on `err.stack` fails). `test-fs-promises-readfile` still passes. Results were identical across two runs.
