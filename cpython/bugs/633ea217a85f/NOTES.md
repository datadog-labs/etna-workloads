Calls PyErr_Format via ctypes with an invalid format string (b'\xff').
Clean: ValueError (format string error) is raised. Buggy: the NULL string is passed to
_PyErr_SetObject, so the failure is not reported properly (assert/crash/wrong exception).
