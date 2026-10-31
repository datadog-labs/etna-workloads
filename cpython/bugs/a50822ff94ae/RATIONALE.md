# Rationale

Single file changed: `tree/Modules/socketmodule.c`, `sock_setsockopt()`.
The fix's hunks (one function) are reversed together, since v3.15.2 still has the post-fix code verbatim:

- Removed the up-front `PyArg_ParseTuple(args, "iiO|I")`, the `arglen` checks (None/4-arg errors), and the `optval` object / `buffer` rename. Restored `Py_buffer optval` and `PyObject *none`.
- AF_VSOCK: restored `PyArg_ParseTuple(args, "iiK")` instead of the `PyIndex_Check` + `PyArg_Parse(optval, "K")` path.
- int path: restored `PyArg_ParseTuple(args, "iii")`, then `PyErr_Clear()`, then the `"iiO!I"` None path, then `"iiy*"` buffer path, dropping the final "socket option should be int, bytes-like object or None" TypeError.

Effect (the original bug): an int that overflows (e.g. `2**100`) fails the `iii` parse, the error is cleared, and the user gets the misleading `TypeError: a bytes-like object is required, not 'int'` rather than `OverflowError`; the other error messages are also generic again.

## Failing oracle case
`test.test_socket.GeneralModuleTests.test_setsockopt_errors`: `setsockopt(SOL_SOCKET, SO_REUSEADDR, 2**100)` raises TypeError instead of OverflowError.
