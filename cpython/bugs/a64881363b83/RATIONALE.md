# gh-128639 reintroduced

Hunk changed: `Py_EndInterpreter` in Python/pylifecycle.c.
Reverses the fix hunk that replaced the `"not the last thread"` fatal check with
stopping the world, `_PyThreadState_RemoveExcept()`, `_PyThreadState_SetShuttingDown()`
and `_PyThreadState_DeleteList()`. In v3.15.2 the world is already stopped by
`make_pre_finalization_calls()`, so the check is placed right after it, and the
thread-removal/deletion block is dropped. Subinterpreter finalization again assumes
a single thread, so closing an interpreter with live threads aborts with
`Fatal Python error: Py_EndInterpreter: not the last thread`.
(The `finalize_subinterpreters()` ordering is already as in the fix and was left alone.)

Expected failing oracle cases: test_interpreters test_api `test_remaining_threads`,
`test_remaining_daemon_threads` (not-the-last-thread abort), and test_threading's
subinterpreter daemon thread test.
