# Rationale

The fix (gh-105987) addressed `swap_current_task` returning `prev_task`, a
borrowed reference from `state->current_tasks`, and only calling `Py_INCREF`
after the dict update that may have dropped the last reference to it (plus a
leak on the error paths). In v3.15.2 the dict is gone: the running task is
stored in `ts->asyncio_running_task` and ownership is transferred to the caller.

Change (Modules/_asynciomodule.c, `swap_current_task`): instead of transferring
the slot's reference, the slot's reference to `prev_task` is released
(`Py_XDECREF`) when the slot is overwritten, and `Py_INCREF(prev_task)` happens
only afterwards. This is the same defect as the fix reversed: the incref comes
after the container drops its reference, so `prev_task` can be freed first.

Failing oracle case: `CEagerTaskFactoryLoopTests.test_issue105987`
(`_swap_current_task(l, DummyTask())` then `_swap_current_task(l, None)`)
crashes the subprocess (use-after-free) and prints to stderr.
