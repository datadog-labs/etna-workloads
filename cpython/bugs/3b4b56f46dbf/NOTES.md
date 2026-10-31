repro.py creates a ctypes.CField with type=c_byte but byte_size=2.
Clean: raises ValueError("byte size of field 'a' (2) does not match type size (1)"), which is printed.
Buggy: the check is an assert, so the debug build aborts (SIGABRT, exit -6) with "Assertion `byte_size == info->size' failed".
