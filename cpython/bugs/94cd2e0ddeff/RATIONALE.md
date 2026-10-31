# gh-129289 reintroduced in Modules/_asynciomodule.c

Fix hunk reversed: moving `unregister_task` out of `TaskObj_finalize` into `TaskObj_dealloc`.
(The `pycore_object.h` hunks are export-only and the test is not touched.)

- `TaskObj_finalize`: unregister_task(task) is called again at the top, as before the fix.
- `TaskObj_dealloc`: removed the unregister_task call that v3.15.2 does after finalization.
  (v3.15.2 already differs from the fix's code in using PyObject_CallFinalizerFromDealloc and an
  explicit untrack, so only the unregister placement was reverted.)

Effect: a Task subclass defining `__del__` replaces tp_finalize with slot_tp_finalize, so
TaskObj_finalize never runs, the task stays linked in the per-thread asyncio task list after
being freed, and the list is left with a dangling node -> crash.

Oracle: the run in test_tasks.py crashes (incomplete run), including
test_task_not_crash_without_finalization and the subsequent tests (1069 of 1133 cases fail).
