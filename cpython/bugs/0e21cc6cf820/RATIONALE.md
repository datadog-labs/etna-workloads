# Rationale

Fix GH-124547: when `_PyDict_DetachFromObject`/detach fails with MemoryError while
deallocating an object whose `__dict__` is materialized and still points at the
inline values, the dict must be cleared (else it keeps dangling inline values).

In v3.15.2 the clearing moved from `_PyDict_DetachFromObject` into the error
branch of `PyObject_ClearManagedDict` (Objects/dictobject.c). The fix's hunk
("Out of memory. Clear the dict": set_keys(Py_EMPTY_KEYS), decref old keys,
STORE_USED 0) corresponds to the `/* Clear the dict */` block there. I removed
that block, so the unraisable MemoryError is still reported but the dict keeps
its keys and a `ma_values` pointer to the freed inline values.

(The `copy_values` PyErr_NoMemory hunk is a pure refactor and was left alone.)

Oracle failure: `test.test_class.TestInlineValues.test_detach_materialized_dict_no_memory`
fails with "the dictionary was not cleared" (`d["a"]` doesn't raise KeyError).
