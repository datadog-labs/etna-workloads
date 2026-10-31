# Rationale

Changed `Lib/multiprocessing/resource_tracker.py`, `ResourceTracker.ensure_running`. This reverses the single implementation hunk of the fix (gh-127586).

- Removed `prev_sigmask = None` and no longer capturing the return value of `pthread_sigmask(SIG_BLOCK, ...)`.
- The `finally` clause goes back to `pthread_sigmask(SIG_UNBLOCK, _IGNORED_SIGNALS)` (guarded by `_HAVE_SIGMASK`) instead of `SIG_SETMASK` with the previous mask. This is the pre-fix code.

The result is that SIGINT and SIGTERM get unblocked in the caller even if the caller had blocked them.

Oracle failure: `TestResourceTracker.test_resource_tracker_blocked_signals` fails. The caller blocks only SIGINT, and after `ensure_running()` the mask no longer contains SIGINT (`AssertionError: Items in the second set but not the first: SIGINT`).
