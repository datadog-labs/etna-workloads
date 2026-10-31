# repro.py

Translated from `test.test_array.LargeArrayTest.test_setitem_use_after_clear_with_int_data`,
added by the upstream fix for gh-142555.

`array.__setitem__` (e.g. `l_setitem` for `'b'`-typed arrays) calls
`__index__()` on the subscript to convert it to a C integer before checking
that the resulting index is within bounds. The script creates a 64-element
`array('b', ...)` and assigns to index 1 using an object whose `__index__()`
clears the array as a side effect (freeing `ob_item` and setting the array's
length to 0).

- On `python-clean` (with the fix / original bounds check), the index is
  re-validated against the array's current (now zero) length after the
  `__index__()` call returns, so `IndexError: array assignment index out of
  range` is raised and the array stays empty. Exit status 0.
- On `python-buggy` (`injection.patch` applied, which removes the
  `CHECK_ARRAY_BOUNDS`/`CHECK_ARRAY_BOUNDS_WITH_CLEANUP` calls), no bounds
  check happens after the index conversion, so the interpreter writes through
  the now-NULL `ob_item` pointer and crashes with SIGSEGV (exit status -11),
  observable via `./check.sh`.
