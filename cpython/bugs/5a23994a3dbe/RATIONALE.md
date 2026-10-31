# Rationale

Only `Objects/abstract.c` `PySequence_Tuple` changed. It reverses the `abstract.c` hunk of
the fix: the buffer/list approach is replaced by the old one, which allocates a tuple using
`PyObject_LengthHint`, fills it while iterating, and grows it with `_PyTuple_Resize`. The
half-filled tuple is therefore visible to the GC and `gc.get_referrers()` while the iterator
runs arbitrary code.

The `_PyList_AsTupleAndClear` helper from the `listobject.c` and `pycore_list.h` hunks is
left in place. It is unused after the revert, and removing it is not needed to bring the bug back.

Oracle: `test_capi.test_tuple.CAPITest.test_bug_59313` fails with
`SystemError: Objects/tupleobject.c:1058: bad argument to internal function`. The tuple gets
resized while `gc.get_referrers` holds a second reference to it. The other 16 cases pass.
