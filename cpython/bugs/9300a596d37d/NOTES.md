repro.py calls fcntl.fcntl() with F_DUPFD and a bytes argument (10 and 2048 bytes) on a closed fd.
Clean: raises OSError(EBADF) both times.
Buggy: the injection inverts the `async_err` check, so the error path returns NULL without setting an exception. The debug build hits the assertion `(res != NULL) ^ (PyErr_Occurred() != NULL)` in ceval.c and aborts.
