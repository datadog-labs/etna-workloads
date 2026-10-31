`repro.py` calls `anext(obj, 1)` where `obj.__anext__` is a plain (sync) method that raises ValueError.
Clean: the ValueError propagates and `ok ValueError('custom')` is printed.
Buggy: the NULL check on `am_anext`'s result is missing, so `anext` with a default crashes (SIGSEGV, exit -11).
