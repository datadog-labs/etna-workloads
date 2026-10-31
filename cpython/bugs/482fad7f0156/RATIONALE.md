# Rationale

Removed `PyObject_ClearWeakRefs(self);` from `typevar_dealloc`, `paramspec_dealloc`
and `typevartuple_dealloc` in Objects/typevarobject.c. These are the three calls
added by the fix (one per hunk). `paramspecattr_dealloc` was not touched by the fix.
Without clearing weakrefs, weakref callbacks/lists dangle on freed objects.

Oracle: `TypeVarTests.test_many_weakrefs` fails and the run crashes
(incomplete run), taking the later TypeVar/TypeVarTuple cases with it.
