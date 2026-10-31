# Rationale

v3.15.2 already contains the fix (shared per-interpreter `__dict__`/`__weakref__` descriptors). I restored the pre-fix per-class descriptors, all in `Objects/typeobject.c`:

- Hunk "Three variants on the subtype_getsets list" (reverses the fix's `subtype_getset_dict/weakref` single defs): restored `subtype_getsets_full`, `_dict_only` and `_weakref_only` arrays.
- Hunk `type_new_set_slots`: restored the selection of `tp_getset` by `tp_weaklistoffset`/`tp_dictoffset` instead of `tp_getset = NULL`. Each heap type therefore gets its own descriptors, with `__objclass__` set to that class.
- Hunks `type_add_common_descriptor` and the calls in `type_new_descriptors`: removed, so the shared cached descriptors are no longer inserted into the class dict. The `dict` parameter of `type_new_descriptors` is now unused, and the cache fields and `_PyTypes_FiniCachedDescriptors` are left in place, harmless.

## Oracle failures
`test_descr.TestGenericDescriptors.test___dict__` and `test___weakref__` fail. `__objclass__` is the class itself, not `object`, and `cls.__dict__['__dict__']` is not shared between classes.
