# Rationale

Fix: gh-126554, handle NULL `dlsym()` results whose `dlerror()` is NULL.
v3.15.2 has the fix in a slightly different form (`_PyErr_SetLocaleString`, `errmsg` name in callproc.c), so the hunks could not be reversed textually.

Pre-fix behaviour restored: after `dlsym()` returns NULL, `dlerror()` is used unconditionally as the message. The `if (dlerr)` guard and the "symbol/function '%s' not found" fallback are no longer reachable on Linux.

- `Modules/_ctypes/_ctypes.c` `CDataType_in_dll_impl`: reverses the `if (dlerr)` check and fallback (`c_int.in_dll`).
- `Modules/_ctypes/_ctypes.c` `PyCFuncPtr_FromDll`: same (`CDLL.foo`).
- `Modules/_ctypes/callproc.c` `py_dl_sym`: same (`_ctypes.dlsym`).

I left the `(void)dlerror()` clearing calls in place, so only the NULL-dlerror handling is reverted.

Oracle: `TestNullDlsym.test_null_dlsym` fails. The IFUNC makes `dlsym()` return NULL with `dlerror()` NULL, so a NULL string goes to `_PyErr_SetLocaleString` and the interpreter crashes. The fixed code raised AttributeError "function 'foo' not found".
