# Rationale

The fix added "interpreter is finalizing" guards. In v3.15.2 these use
`_PyInterpreterState_GetFinalizing(interp) != NULL` and raise `PythonFinalizationError`.
I removed each guard, which restores the pre-fix behaviour of no check.

- Modules/_threadmodule.c `do_start_new_thread` reverses the `_thread.start_new_thread` hunk (the "can't create new thread at interpreter shutdown" check).
- Modules/posixmodule.c `os_fork1_impl`, `os_fork_impl` and `os_forkpty_impl` reverse the three "can't fork at interpreter shutdown" hunks.
- Modules/_posixsubprocess.c `subprocess_fork_exec_impl` reverses the "preexec_fn not supported at interpreter shutdown" hunk.

No generated files are affected.

## Oracle result
`test_threading.ThreadTests.test_start_new_thread_at_finalization` fails: starting a thread from an atexit handler no longer raises. Stderr is empty instead of containing the shutdown error.
