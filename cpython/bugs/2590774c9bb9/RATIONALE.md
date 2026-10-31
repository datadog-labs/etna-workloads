# Rationale

Hunk reversed: `Modules/_ctypes/_ctypes.c`, `PyCPointerType_set_type_impl`.
The fix replaced `PyDict_SetItem(type_dict, "_type_", type)` (plus the
`attrdict` fetch/DECREF bookkeeping) with `PyObject_SetAttr(self, "_type_", type)`.
I restored the old code exactly: it writes `_type_` straight into the type's
dict and bypasses `type.__setattr__`, so the type attribute cache is not
invalidated and a stale `_type_` can be read after `set_type()`.

Failing oracle cases (3): `test_repeated_set_type` and
`test_pointer_set_wrong_type`, plus one more `PointersTestCase` case. They fail
with e.g. `AssertionError: <class 'ctypes.LP_LP_C'> is not <class 'ctypes.c_int'>`,
because the cached `_type_` is returned after `set_type`.
