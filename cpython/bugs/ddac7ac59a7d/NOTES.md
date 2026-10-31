Reproducer: a function with a default arg (`def test(default=None): return test()`) recurses infinitely.
Calls with defaults are specialized to CALL_PY_GENERAL, which (with the bug) skips the recursion check.
Clean: prints `RecursionError`, exit 0. Buggy: never raises (hang/timeout instead of RecursionError).
