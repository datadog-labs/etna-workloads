# Rationale

Changed: `Lib/asyncio/staggered.py`, `staggered_race`. I removed the
final `if propagate_cancellation_error is not None: raise propagate_cancellation_error`.

Fix hunk reversed: the fix added re-raising of the cancellation
(`propagate_cancellation_error`). Before the fix, a cancellation that arrived
while `staggered_race` was waiting was swallowed. The children were cancelled,
but the function then returned normally. The caller never saw the
`CancelledError`, so enclosing `asyncio.timeout()` scopes did not fire. The
rest of the new structure (the done-callback, the `running_tasks` set and the
`ExceptionGroup`) is kept, because reversing it would amount to a full rewrite.
Only the cancellation-propagation behaviour is restored to its pre-fix state.

Oracle: `test_cancelled` fails with `AssertionError: TimeoutError not raised`.
The other six cases still pass.
