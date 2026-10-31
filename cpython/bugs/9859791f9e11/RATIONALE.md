# Rationale (gh-128639 / gh-128640)

## Changed: `Py_EndInterpreter` in Python/pylifecycle.c
Reverses the fix hunk that replaced the `"not the last thread"` fatal check with
`_PyThreadState_RemoveExcept(tstate)` + `_PyThreadState_DeleteList(list)`.
In v3.15.2 that code lives after `make_pre_finalization_calls`. I restored the
check (`tstate != interp->threads.head || tstate->next != NULL` -> `Py_FatalError`)
and removed the RemoveExcept / SetShuttingDown / DeleteList calls, so a subinterpreter
that still has other (e.g. daemon) threads aborts again instead of having them removed.

The `finalize_subinterpreters` hunks were already in their fixed form and I left them
alone (the old "assume one tstate" code is gone, and reverting it isn't needed).

## Failing oracle case
`test.test_threading.SubinterpThreadingTests.test_daemon_threads_fatal_error` fails:
"Fatal Python error: Py_EndInterpreter: not the last thread" with a daemon thread
left in the subinterpreter, which is the crash the fix removed.
