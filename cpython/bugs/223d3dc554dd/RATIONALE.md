# Rationale (gh-125631, Modules/_pickle.c)

The fix added `persistent_id_attr` / `persistent_load_attr` fields plus custom
`tp_getattro`/`tp_setattro` slots on `Pickler` and `Unpickler`, so that
`persistent_id` / `persistent_load` can be set as instance attributes. I removed
all of it, restoring the pre-fix state:

- struct fields `persistent_id_attr`, `persistent_load_attr`, and their init,
  clear and traverse handling (reverses the struct/`_New`/clear/traverse hunks);
- `Pickler_getattr/setattr`, `Unpickler_getattr/setattr` and their
  `Py_tp_getattro`/`Py_tp_setattro` slot entries.
- `pickler_get_optional_attr` (added later, not in the fix) compared
  `tp_getattro` to `Pickler_getattr`; it now compares to `PyObject_GenericGetAttr`,
  which is what the type uses again. Behaviour is otherwise unchanged.

Instances again have no way to store these attributes, so assignment raises
AttributeError (the pre-fix behaviour).

## Oracle failures
- `SizeofTests.test_pickler` / `test_unpickler` (sizes lost one pointer: 144 != 152, 296 != 304).
- The new `test_pickler_instance_attribute`, `test_unpickler_instance_attribute` and the
  `*_super_instance_attribute` variants error with AttributeError on assignment
  (the 8 errors).
