repro.py calls `_testcapi.pylong_aspid` (PyLong_AsPid) with ints just outside the 32-bit pid_t range.
Clean: raises OverflowError for 2**31 and -2**31-1.
Buggy: PyLong_AsPid is plain PyLong_AsLong, so the value is silently truncated (2**31 -> -2147483648, -2**31-1 -> 2147483647).
