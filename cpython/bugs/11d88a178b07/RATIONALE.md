# Rationale

The fix made `shutil.rmtree` report `os.close()` failures to the error handler
as `os.close` (and not retry close). v3.15.2 rewrote `_rmtree_safe_fd` as an
iterative stack walk, so the fix's hunks don't apply; the equivalent logic is in
`Lib/shutil.py`.

1. `_rmtree_safe_fd_step`, `func is os.close` branch: set `func = os.rmdir`
   before `os.close(dirfd)`. This reverses the fix's `except OSError` around
   `os.close` that called `onexc(os.close, ...)`. Pre-fix, close and rmdir
   shared one try block, so a close error was reported as an rmdir error.
2. `_rmtree_safe_fd` cleanup loop: removed the `try/except OSError ->
   onexc(os.close, ...)` around `os.close(fd)`. This reverses the fix's
   `finally: try: os.close ... except: onexc(os.close, ...)` hunks. Close errors
   there now propagate raw and bypass `ignore_errors`/`onexc`.

Failing oracle case: `test_shutil.TestRmTree.test_rmtree_fails_on_close`. With an
`onexc` handler, `errors[0][0]` is `os.rmdir` rather than the failing `close`.
