# gh-89811 reintroduced in Python/specialize.c

The fix added `type_get_version()` checks (fail specialization when `tp_version_tag == 0`)
in LOAD_ATTR, STORE_ATTR, class LOAD_ATTR, CALL (class) and TO_BOOL. In v3.15.2 the checks
are done on the `tp_version` returned by the lookup. I removed the version==0 bail-outs:

- `do_specialize_instance_load_attr`: removed `if (tp_version == 0) {... return -1;}` (fix hunk `_Py_Specialize_LoadAttr`).
- `_Py_Specialize_StoreAttr`: removed `if (tp_version == 0) goto fail;` (fix hunk `_Py_Specialize_StoreAttr`).
- `specialize_class_load_attr`: removed the `tp_version == 0` return -1 (fix hunk `specialize_class_load_attr`).
- `specialize_class_call`: removed the `!tp_version` return -1 (fix hunk `specialize_class_call`).

TO_BOOL (`_PyType_Validate` path) was left untouched; it still rejects version 0.

Result: specializations are written with a version of 0 in the cache, so type-version
guards are unusable. Running the oracle, the test process crashes (assert/crash in the
specialized path), so all 12 oracle cases are reported failing (incomplete run); the
specialization tests expecting `should_specialize=False` are the ones the fix guards.
