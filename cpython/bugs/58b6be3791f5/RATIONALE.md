# Rationale

Changed `weakref_repr` in `tree/Objects/weakrefobject.c`. This reverses the single implementation hunk of fix.patch.
v3.15.2 already used `_PyObject_LookupSpecial(obj, __name__)`. I restored the pre-fix instance attribute lookup, using
`PyObject_GetOptionalAttr` (the current name of `_PyObject_LookupAttr`) with the same error handling (decref and return NULL on error).

A class whose `__getattr__` raises a non-AttributeError (e.g. KeyError) now makes `repr(weakref.ref(obj))` fail.

Oracle case that fails: `test.test_weakref.ReferencesTestCase.test_repr_failure_gh99184` (KeyError: '__name__' from `repr`).
