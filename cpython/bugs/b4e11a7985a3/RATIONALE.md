# Rationale

Fix hunk reversed: `PyCSimpleType_from_param` in `Modules/_ctypes/_ctypes.c`
(now `PyCSimpleType_from_param_impl`). The fix replaced `PyErr_Clear()` with
fetching the setfunc's exception, and restored it at the end instead of the
generic "wrong type". Here, the saved exception (`PyErr_GetRaisedException`)
and all its cleanup/restore paths are removed: the error is cleared and
`TypeError("wrong type")` is always raised, as before the fix. The
`_as_parameter_` paths simply drop the now-nonexistent `exc` cleanup.

Failing oracle cases: `test_parameters.SimpleTypesTestCase.test_c_char` and
`test_c_wchar` (message is "wrong type" instead of the detailed message).
The `test_functions` `ArgumentError` message cases are expected to fail the same way.
