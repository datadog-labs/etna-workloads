Reproducer for gh-145492: defaultdict.__repr__ calls Py_ReprLeave on the factory even when Py_ReprEnter failed.
The factory's __repr__ calls repr() on the defaultdict itself (and formats it).
Clean: prints `defaultdict(F for defaultdict(..., {}), {})`.
Buggy: the recursion guard is left early, so repr recurses infinitely and prints `RecursionError`.
