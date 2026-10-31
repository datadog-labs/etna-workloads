repro.py: a ctypes Structure with two pointer fields (larger than sizeof(void*)) defines `from_param()` returning a new instance. It is used as an argtype for `_testfunc_pylist_append`, which appends to a list during the call.

Clean: trace is `[1, 2, 3, 4, 5]` (the from_param result lives until the call ends).
Buggy: trace is `[1, 2, 4, 3, 5]` (the result is freed too early, so `__del__` runs before the call).
