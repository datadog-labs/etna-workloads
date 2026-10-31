# Rationale

Hunk changed: `Modules/_ctypes/_ctypes.c`, `StructUnionType_paramfunc`: removed
`struct_param->keep = Py_NewRef(self);`.

This reverses the fix's third `_ctypes.c` hunk. The fix also added the `keep` field
and its `Py_XDECREF` in dealloc. In v3.15.2 those are now `keep` in
traverse/clear, which handle NULL, so they stay. Never setting `keep` restores the
original behavior: for structs larger than a pointer, the copied-parameter object
no longer holds the from_param() result, so the result is destroyed early.

Oracle failure: `test_from_param_result_refcount` fails with
`[1, 2, 4, 3, 5] != [1, 2, 3, 4, 5]`. The `__del__` of the Y struct (size > pointer) runs before the call.
