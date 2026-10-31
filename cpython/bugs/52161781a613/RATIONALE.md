# Rationale

Only the Semaphore half of the fix (GH-111693) is re-introducible in v3.15.2.
The Condition.wait() re-raise of the same CancelledError instance, and the
`_make_cancelled_error` context change in futures.py, are already structured
differently in 3.15 (no `__context__` assignment), so they were left alone.

## Changed: `Semaphore.acquire` in Lib/asyncio/locks.py
Reverses the fix hunk that changed the `except CancelledError` branch and
replaced the post-await `if self._value > 0: self._wake_up_next()` with a
`finally:` loop waking as many waiters as `_value` allows.
Restored pre-fix code:
- on cancel, `if not fut.cancelled(): self._value += 1; self._wake_up_next()`
- on success, a single `if self._value > 0: self._wake_up_next()`

So a successful acquire wakes at most one further waiter, and the cancel
path races with waiters. Waiters queued due to FIFO rules are not all woken.
`_wake_up_next` still returns True/False; the pre-fix callers ignore it.

## Oracle failure
`SemaphoreTests.test_acquire_fifo_order_4` fails: in c1,
`sem._value` is 1 instead of 0, because only one extra waiter was woken after
c1's acquire.
