Calls `agen.athrow()` with no arguments and prints the result.
Clean: TypeError raised immediately ("athrow expected at least 1 argument, got 0").
Buggy: arguments are only checked when the awaitable runs, so no error at call time.
