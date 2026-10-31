# Rationale

Bug (gh-106403): TypeVar, ParamSpec, ParamSpecArgs, ParamSpecKwargs and TypeVarTuple lacked
`Py_TPFLAGS_MANAGED_WEAKREF`, so `weakref.ref(...)` raised TypeError.

Changes, all in `Objects/typevarobject.c`:
- `typevar_spec`, `paramspecargs_spec`, `paramspeckwargs_spec`, `paramspec_spec`, `typevartuple_spec`:
  removed `Py_TPFLAGS_MANAGED_WEAKREF`. This reverses the five flag hunks of the fix exactly.
- Removed `PyObject_ClearWeakRefs(self)` from `typevar_dealloc`, `paramspecattr_dealloc`,
  `paramspec_dealloc` and `typevartuple_dealloc`. These calls do not exist in the 2023 pre-fix code.
  They were added later. Without the flag they raise in debug builds ("Deallocator ... raised an
  exception"), which aborted the build, so they must go with the flag. This is the same defect.

Oracle: the 6 errors in `test_type_params` are the new `TypeParamsWeakRefTest.test_weakrefs`
subtests, failing with `TypeError: cannot create weak reference to 'TypeVar' object` and the same
for ParamSpec, ParamSpecArgs, ParamSpecKwargs and TypeVarTuple.
