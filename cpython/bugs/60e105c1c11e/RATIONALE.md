# Rationale

Fix: gh-113964 changed the "no new threads / no fork / no preexec_fn during
shutdown" checks from `interp->finalizing` to `_PyInterpreterState_GetFinalizing(interp) != NULL`.
In v3.15.2 `_Py_Finalize()` (Python/pylifecycle.c) still sets
`tstate->interp->finalizing = 1` ("Block some operations") *before*
`make_pre_finalization_calls()` waits for non-daemon threads, while
`_PyInterpreterState_SetFinalizing()` happens only after. So restoring the old
flag check reintroduces the bug. No change in pylifecycle.c was needed.

Hunks reverted (each restores `interp->finalizing`):
- Modules/_posixsubprocess.c: preexec_fn check (fix hunk 1).
- Modules/_threadmodule.c `do_start_new_thread` (fix hunk 2).
- Modules/posixmodule.c: `os_fork1`, `os_fork`, `os_forkpty` (fix hunks 3-5; in 3.15.2 the three sites are in os_fork1/os_fork/os_forkpty).
- Objects/unicodeobject.c `unicode_check_encoding_errors` (fix hunk 6).

Oracle failure: `test_threading.ThreadJoinOnShutdown.test_thread_from_thread`
fails: a non-daemon thread starting another thread while the main thread waits
for non-daemon threads now raises PythonFinalizationError
("can't create new thread at interpreter shutdown") in Thread-1.
