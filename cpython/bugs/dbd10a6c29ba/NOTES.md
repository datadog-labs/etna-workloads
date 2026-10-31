Reproducer for gh-142881: `atexit.unregister()` with an `__eq__` that itself calls `atexit.unregister()` (reentrant).
It is a translation of `test_eq_unregister`. It registers f1, f2, f3, then unregisters a `Pred()` whose `__eq__` unregisters another callback on the Nth comparison. It prints the callbacks that are left and run.
Clean output is `[3]`, `[3, 1]` or `[1]`, depending on which callback was removed. The buggy interpreter removes the wrong entries. Examples: `f2 2` gives `[3]` and `f3 1` gives `[2, 1]`.
