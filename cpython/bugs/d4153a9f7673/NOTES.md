Calls `_testinternalcapi._pyerr_setkeyerror(arg)` (the helper added by the fix), which sets MemoryError and then calls `_PyErr_SetKeyError(arg)`.
Clean: the pending exception is replaced and KeyError with args `(arg,)` is raised for each arg.
Buggy: `_PyErr_SetKeyError` no longer clears the pending exception, so `_Py_CheckFunctionResult` hits a fatal error (abort, exit -6).
