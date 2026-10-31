Reproducer for the PyErr_CheckSignals / PyThreadState_SetAsyncExc bug.

A daemon thread sleeps in `time.sleep(86400)`. The main thread schedules an async
exception with `_testlimitedcapi.threadstate_set_async_exc`, then sends SIGUSR1 to
the thread for up to 3s so that `sleep` wakes and calls `PyErr_CheckSignals`.

- clean: the thread raises the injected exception and exits. Output: `1` then `False Injected`.
- buggy: `PyErr_CheckSignals` doesn't raise the pending async exception, so sleep resumes.
  Output: `1` then `True NoneType`. The thread is still alive and nothing was caught.
