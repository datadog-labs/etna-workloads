# Rationale

Fix hunk (Modules/atexitmodule.c, `atexit_unregister_locked`): take a strong
reference to the callback tuple (`Py_NewRef`) and `Py_DECREF` it after
`PyObject_RichCompareBool`, so a `__eq__` that calls `atexit.unregister` or
`atexit._clear` cannot free the tuple (and `to_compare`) mid-comparison.

In v3.15.2 the function was reworked (reverse iteration, index re-search, the
reference is released on several paths). I reversed the fix by restoring the
borrowed reference: `tuple = PyList_GET_ITEM(callbacks, i)` with no
`Py_NewRef`, and removed the three matching `Py_DECREF(tuple)` calls (error
return after compare, error return after `PyList_SetSlice`, and the one at the
end of the loop body). The result is the pre-fix behaviour: the tuple is only
borrowed from the list while arbitrary Python code runs in `__eq__`.

## Oracle failures
`test_eq_unregister_clear` crashes the interpreter (use-after-free: `_clear()`
inside `__eq__` frees the tuple and callback). The other listed failing cases
are reported because the test process crashed (incomplete run).
