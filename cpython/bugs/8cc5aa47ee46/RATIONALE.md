# gh-87135 reintroduced

Fix hunk reversed: `Python/ceval_gil.c`, the three `PyThread_exit_thread()` -> `PyThread_hang_thread()` replacements in `take_gil()` (entry `_PyThreadState_MustExit` check, the timed-wait check, and the post-wait check).
In v3.15.2 these are spelled `_PyThreadState_HangThread(tstate)` (which decrefs the tstate and calls `PyThread_hang_thread()`). I put back `PyThread_exit_thread()` at all three sites, which is the pre-fix behaviour: a daemon thread that takes the GIL during finalization is terminated with `pthread_exit` instead of hanging.
The other hunks (docs, deprecation, `PyThread_hang_thread` definitions, `_testcapi` helper, comments) are not behavioural and were left alone. The `PyGILState_Ensure` hang in pystate.c is later code, not part of this fix, and is untouched.

## Oracle
`test.test_threading.ThreadTests.test_finalize_daemon_thread_hang` fails. The daemon thread is woken during finalization, `pthread_exit` triggers the `pthread_cleanup_push` callback, and `Py_FatalError("pthread thread termination was triggered unexpectedly")` aborts the process. The other 238 oracle cases pass.
