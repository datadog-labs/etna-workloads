# Rationale

Fix hunk reversed: `Objects/object.c` `PyObject_GenericSetDict`. The fix replaced the
body (which used `_PyObject_GetDictPtr` and wrote straight through the dict pointer) with a
call to the new shared `_PyObject_SetDict`. In v3.15.2 `_PyObject_SetDict` already exists
(in typeobject.c, used by `subtype_setdict`), so I restored the pre-fix body in
`PyObject_GenericSetDict` only; the typeobject.c refactor is left alone.

Pre-fix behaviour: for a type with `Py_TPFLAGS_MANAGED_DICT` / inline values, the
`*dictptr` store bypasses the managed-dict machinery (`_PyObject_SetManagedDict`), so
the assigned dict is not used for attribute lookup (inline values still win).

Oracle failure: `test_capi.test_type.TypeTests.test_extension_managed_dict_type` fails
at `self.assertEqual(obj.bar, 3)` with
`AttributeError: '_testcapi.ManagedDictType' object has no attribute 'bar'`.
