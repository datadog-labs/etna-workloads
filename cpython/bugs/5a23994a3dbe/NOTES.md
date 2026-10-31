Reproducer: builds a tuple from a generator that calls `gc.get_referrers()` mid-construction (port of test_bug_59313).
Clean: prints `True` and `0` (no partial tuple visible to the GC).
Buggy: `tuple(my_iter())` raises `SystemError: bad argument to internal function`, because the partially built tuple is exposed and then resized.
