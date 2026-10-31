# Rationale (gh-102780, asyncio.timeout uncancel fix)

Changes, all in `tree/Lib/asyncio/timeouts.py`, reversing the `timeouts.py` hunks of fix.patch:

- `__aenter__`: removed `self._cancelling = self._task.cancelling()` (fix hunk 1; the fix added it).
- `__aexit__`: `self._task.uncancel() <= self._cancelling` -> `self._task.uncancel() == 0`
  (fix hunk 2). Timeout is again only recognised when no cancel requests are outstanding at all,
  so a task already being cancelled before entering the timeout gets CancelledError, not TimeoutError.
- `raise TimeoutError from exc_val` -> `raise TimeoutError`, so CancelledError lands in
  `__context__` instead of `__cause__`.

The v3.15.2 code was restructured (exception groups, `exc_type is not None`), which is kept as is.

## Oracle failures
- `test_timeout_after_cancellation`: CancelledError raised instead of TimeoutError.
- `test_nested_timeout_in_finally`: same cause (uncancel() != 0 in cleanup).
- `test_timeout_exception_context`: cancel error not found in the expected `__cause__`.
