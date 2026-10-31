Reproducer: lowers RLIMIT_NPROC soft limit to 0, then calls `_thread.start_joinable_thread(f)` so the underlying OS thread creation fails and a RuntimeError is raised ("ok" is printed).

Clean: prints `ok`, exits 0.
Buggy: prints `ok`, then at interpreter finalization aborts with `Assertion 'tstate->_status.initialized && !tstate->_status.cleared' failed` in PyThreadState_Clear (exit -6). The failed thread's state was not deleted, so it gets cleaned up twice.

Not effective when run as superuser (RLIMIT_NPROC is ignored).
