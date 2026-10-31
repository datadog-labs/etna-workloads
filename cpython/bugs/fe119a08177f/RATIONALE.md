# Rationale

## Python/lock.c (`_PyMutex_LockTimed`)
Reverses the fix hunk that added, before parking, the check
`if ((flags & _PY_LOCK_PYTHONLOCK) && Py_IsFinalizing()) { PyErr_SetString(PyExc_PythonFinalizationError, ...); return PY_LOCK_FAILURE; }`.
I removed that block, so a contended Python lock acquired during finalization
parks forever instead of raising PythonFinalizationError. The flag and the
_threadmodule.c callers are left as they are, since they are inert without this check.
The RLock path goes through `_PyMutex_LockTimed`, so it is covered too.

## Oracle
`test_threading` `test_acquire_daemon_thread_lock_in_finalization` (Lock and RLock) should
fail: the child process hangs at shutdown (or times out) instead of printing
"got the correct exception!".
