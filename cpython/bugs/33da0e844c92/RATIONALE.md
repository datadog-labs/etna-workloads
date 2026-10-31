# Rationale

The fix (gh-114271) replaced `_tstate_lock` with a `PyEvent`-based `ThreadHandle`
and added `check_started()` to `ThreadHandle_join` and `ThreadHandle_set_done`
(raising "thread not started"). v3.15.2 already contains the event design, so the
original race cannot be restored literally. The one recognisable piece of the fix
that remains is the `check_started()` guard.

## Change
`Modules/_threadmodule.c`, `ThreadHandle_set_done`: removed the
`if (check_started(self) < 0) return -1;` guard. This reverses the fix hunk that
added `check_started` and its call in `ThreadHandle_set_done`. A handle that was
never started now goes straight into `set_done()`, which asserts the state is
RUNNING.

I did not remove the guard from `ThreadHandle_join`. Without it, joining an
unstarted handle waits forever on an event nobody sets.

## Oracle failures
`test_thread.test_set_done_unstarted` fails: no `RuntimeError("thread not started")`
is raised, and the debug build's assert crashes the run. The run is incomplete, so
`test_stack_size`, `test_start_duplicate_handle`, `test_start_with_none_handle` and
`test_unraisable_exception` are also reported as failing, but only because of the crash.
