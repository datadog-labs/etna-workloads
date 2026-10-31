`repro.py` warms the type attribute cache by reading `POINTER(C)._type_` several times, then calls `set_type(c_int)` and prints `ptr._type_`.

- clean: `<class 'ctypes.c_int'>`
- buggy: `<class '__main__.C'>`. The buggy `set_type` writes `_type_` straight into the type's dict with `PyDict_SetItem`, which skips cache invalidation, so the stale value is returned.
