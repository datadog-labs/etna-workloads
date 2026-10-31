# Rationale (gh-124958)

Fix hunks reversed in v3.15.2:

1. `Lib/asyncio/futures.py`, `Future.result()` / `Future.exception()`: restored
   `exc = self._make_cancelled_error(); raise exc`. The local `exc` forms a
   frame <-> exception <-> traceback cycle, as before the fix.
   (Only the Python `_PyFuture` is affected; the C future never had this.)
2. `Lib/asyncio/taskgroups.py`, `__aexit__`: removed the wrapper that cleared
   `tb`, `exc`, `self._parent_task`, `self._errors`, `self._base_error` in a
   `finally`. `__aexit__` now just does `return await self._aexit(et, exc)`.
   The `_aexit` body (already with its per-raise `exc = None` finally blocks) is
   left alone, so the TaskGroup keeps references to the exceptions
   and the `__aexit__` frame keeps `exc`.

Oracle failures: 10 test_taskgroups cases (`test_exception_refcycles_base_error`,
`_errors`, `_parent_task`, `_parent_task_wr`, `_propagate_cancellation_error`,
in both TestTaskGroup and TestEagerTaskTaskGroup). `gc.get_referrers(exc)` now
returns the leaked `__aexit__` frame instead of `[]`.
