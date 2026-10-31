# Rationale

Hunk reversed: `Lib/multiprocessing/resource_tracker.py`, `ResourceTracker.ensure_running`
(the only implementation hunk of the fix). The code had moved but is otherwise identical.

- Dropped `prev_sigmask`, the return value of `pthread_sigmask(SIG_BLOCK, ...)`.
- The `finally` clause again calls `pthread_sigmask(SIG_UNBLOCK, _IGNORED_SIGNALS)` guarded by `_HAVE_SIGMASK`.

This is the pre-fix code. SIGINT and SIGTERM are unblocked in the caller even if the caller had them blocked before.

Oracle: `TestResourceTracker.test_resource_tracker_blocked_signals` fails. With only SIGINT blocked
before `ensure_running()`, the mask afterwards no longer contains SIGINT (`AssertionError: Items in the second set but not the first: SIGINT`).
