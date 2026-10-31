Calls `_testcapi.exc_set_object(OSError, PermissionError(24))` (PyErr_SetObject with an instance of a subclass).
Clean: raises PermissionError with args (24,). Buggy: the subclass check is replaced by an exact-type check,
so the instance is wrapped: raises OSError with args (PermissionError(24),).
