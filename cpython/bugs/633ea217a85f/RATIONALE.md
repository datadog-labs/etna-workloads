# Rationale

All changes are in `tree/Python/errors.c`; they reverse the `Python/errors.c` hunks of the fix.

- `_PyErr_SetString`: restored the unconditional `_PyErr_SetObject(..., value); Py_XDECREF(value);`. If `PyUnicode_FromString` fails (e.g. undecodable bytes), the decode error is overwritten or ignored.
- `_PyErr_FormatV`: restored the unconditional `_PyErr_SetObject(..., string); Py_XDECREF(string);`, so a failed `PyUnicode_FromFormatV` no longer keeps its error.
- `PyErr_SetFromErrnoWithFilename`: removed the `name == NULL` early return (v3.15.2 still has the `errno` save/restore, which I kept). A filename decode failure is now ignored.
- The Windows variants (`PyErr_SetExcFromWindowsErrWithFilename`, `PyErr_SetFromWindowsErrWithFilename`) were not reverted. They are not built on Linux.

## Failing oracle cases
`test_set_string` fails: `setstring(ZeroDivisionError, b'\xff')` raises ZeroDivisionError instead of UnicodeDecodeError. A second case also fails, with the same kind of wrong exception. It is probably `test_format` or `test_setfromerrnowithfilename`, but I did not check which.
