# Rationale

Hunk reversed: `Modules/_functoolsmodule.c`, `partial_vectorcall` (fix hunk of the same function).
v3.15.2 uses `partial_keywords` instead of `pto->kw`. The fix stored `PyDict_Contains()`'s result and went to the
error path when it was negative. I restored the pre-fix form, `if (PyDict_Contains(partial_keywords, key))`, so an
error return (-1) is treated as true.

Oracle: `TestPartialC.test_str_subclass_error` and `TestPartialCSubclass.test_str_subclass_error` fail.
`__eq__` raises, `PyDict_Contains` returns -1 with an exception set, and the code carries on into
`PyDict_SetItem` with the error still set. The interpreter crashes (assert or segfault), which is the
crash the fix guards against. The run aborts, so the other cases in the file are reported as failing too.
