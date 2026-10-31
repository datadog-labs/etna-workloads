Reproducer: a dict whose value is its own `values()` view; prints `repr(d)`.
Clean: prints `{1: dict_values([...])}` (recursion guarded by Py_ReprEnter).
Buggy: dictview_repr lacks the Py_ReprEnter guard, so repr recurses infinitely -> RecursionError.
