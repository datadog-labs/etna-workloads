# Rationale

Fix hunk reversed: `Objects/object.c`, `_PyNone_Type.tp_richcompare` changed from
`_Py_BaseObject_RichCompare` back to `0`. The helper `_Py_BaseObject_RichCompare`
(typeobject.c / pycore_typeobject.h) is left in place because it is still used by
`sentinelobject.c` in v3.15.2; only the None type's use of it is removed, which is
exactly what the fix added.

With `tp_richcompare == 0`, `None.__ne__` is inherited via the slot wrapper in a way that
yields `NotImplemented` for `None.__ne__(None)` instead of `False`.

Oracle failure: `test.test_builtin.BuiltinTest.test___ne__`
(`assertFalse(None.__ne__(None))` fails; the result is `NotImplemented`).
