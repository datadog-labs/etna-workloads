# Rationale

Changed `property_init_impl` in `Objects/descrobject.c`, in the non-exact-`property` branch that stores `__doc__` via `PyObject_SetAttr`.

Fix hunk reversed: the one that added `PyErr_ExceptionMatches(PyExc_AttributeError)` / `PyErr_Clear()` / `return 0` after a failed `SetAttr`. In v3.15.2 that handling had an extra `!self->getter_doc` condition (this preserves the "getter docstring still raises" case, which replaces the fix's separate pre-check hunk). I removed the whole swallow block, so any `SetAttr` failure returns -1, which is the pre-fix behaviour. The fix's other hunks (the pre-check for getter docs and the Python-reference-code comment) are not touched.

Failing oracle cases:
- `test_property_with_slots_no_docstring`: `slotted_prop()` on a `__slots__` subclass raises `AttributeError: ... '__doc__' is read-only`.
- `test_property_with_slots_docstring_silently_dropped`: `slotted_prop(doc="what's up")` raises the same error.
