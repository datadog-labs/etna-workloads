## What the reproducer does

`repro.py` defines a `property` subclass `pro` whose `__new__` returns a
plain `str` instead of a `pro`/`property` instance. It creates
`p = property.__new__(pro)` (a real `property` object, since `__new__` is
only overridden on the subclass, not used here) and calls `p.getter(None)`,
which internally calls `property_copy()` in `Objects/descrobject.c`.
`property_copy()` calls `type(p)->tp_new` (i.e. `pro.__new__`) to build the
copy; since that returns a `str`, the result `new` is not a `property`
instance at all.

The result is printed with `repr()`.

## What differs between the interpreters

- **clean** (upstream fix present): `property_copy()` checks
  `PyObject_TypeCheck(new, &PyProperty_Type)` before writing
  `((propertyobject *) new)->prop_name`, so the non-property `str` result is
  left untouched and returned as-is. Output: `'abcdef'`, exit status 0.
- **buggy** (`injection.patch` applied, reverting the fix): the type check is
  removed, so `property_copy()` unconditionally reinterprets the `str`
  object's memory as a `propertyobject` and writes a `Py_XSETREF` into the
  field at `prop_name`'s offset, corrupting the string object. This crashes
  the interpreter (`exit status -11`, SIGSEGV) instead of returning normally.
