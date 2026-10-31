# Rationale

Reverses the gh-124958 fix (refcycles in TaskGroup / pure-Python Future exceptions).

- `Lib/asyncio/futures.py`, `Future.result()` and `Future.exception()`: restored
  `exc = self._make_cancelled_error(); raise exc`, reversing the fix's
  `raise self._make_cancelled_error()` hunks. The local `exc` and the traceback
  form a frame<->exception reference cycle again.
- `Lib/asyncio/taskgroups.py`, `__aexit__`: removed the wrapper that calls `_aexit`
  and in `finally` clears `_parent_task`, `_errors`, `_base_error` and `exc`
  (the fix's `__aexit__`/`_aexit` split hunk). The body of `_aexit` is inlined
  back into `__aexit__`. The TaskGroup now keeps references to the parent task,
  errors and base error after exit, so exceptions stay in cycles.
  The per-raise `finally: exc = None` blocks were left in place (current code
  has additional logic there, e.g. the GeneratorExit case).

Failing oracle cases: test_futures `test_future_cancelled_result_refcycles` and
`test_future_cancelled_exception_refcycles` (pure-Python future; gc.get_referrers(exc) is non-empty);
test_taskgroups `test_exception_refcycles_base_error`, `_errors`, `_parent_task`,
`_parent_task_wr` (both TestTaskGroup and TestEagerTaskTaskGroup).
