# Rationale

Bug: error messages from C libraries (dlerror(), gdbm_strerror()) are locale-encoded but were passed to PyErr_SetString(), which decodes as UTF-8 strict, so a non-UTF-8 message raises UnicodeDecodeError instead of the intended exception.

Hunks reversed (the fix's use of `_PyErr_SetLocaleString`, which still exists in v3.15.2):
- `Modules/_ctypes/callproc.c` `py_dl_open`: back to `PyErr_SetString(PyExc_OSError, errmsg)` with the "dlopen() error" fallback (fix hunk @@ -1588).
- `Modules/_ctypes/callproc.c` `py_dl_close`: back to `PyErr_SetString(PyExc_OSError, dlerror())` (fix hunk @@ -1604).
- `Modules/_gdbmmodule.c` `set_gdbm_error`: body is the old `PyErr_SetString(state->gdbm_error, gdbm_strerror(gdbm_errno))`. All call sites go through this helper, so it covers the five call-site hunks.

The `_ctypes.c` and `py_dl_sym` hunks were not reverted: pre-fix code there already used PyUnicode_DecodeLocale, so they were refactors, not bug fixes.

Oracle: `test_localized_error_dlopen` fails with `UnicodeDecodeError: 'utf-8' codec can't decode byte 0xff`. The gdbm `test_localized_error` still passes (the gdbm message is ASCII in this environment).
