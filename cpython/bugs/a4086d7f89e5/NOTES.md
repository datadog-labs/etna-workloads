Reproducer for the use-after-free in `Context.__eq__` (gh-142829). A value's `__eq__` calls `var.set()` on the context being compared, replacing the HAMT mid-comparison.
Clean: prints `True`, exit 0. Buggy: the debug build aborts with an assertion in `hamt_iterator_next` (exit -6), because `_PyHamt_Eq` no longer holds references on the HAMTs.
