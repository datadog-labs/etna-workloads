# Rationale

## Objects/moduleobject.c, `_PyModule_IsPossiblyShadowing`
Fix hunk: when `_Py_wgetcwd` fails, return 0 (no exception, assume no shadowing) instead of `return -1`.
In v3.15.2 the code uses `goto done` with `result = 0` for this case (to free buffers). I restored the old
behaviour by setting `result = -1` before `goto done`, so -1 is returned with no exception set.
The caller then calls `_PyObject_SetAttributeErrorContext` with no exception raised.

## Oracle
`test_script_shadowing_stdlib_cwd_failure` fails: the child process aborts with
`Assertion 'PyErr_Occurred()' failed` in `_PyObject_SetAttributeErrorContext` (object.c), the same assertion
quoted in the fix's commit message. The other failures in the run (test_import, PycacheTests.*) appear
environment-related (non-ASCII tmp path), not related to this change.
