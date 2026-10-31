`repro.py` evaluates `c = a or b` where `Foo.__bool__` raises NotImplementedError, inside try/except.
Clean: the exception is caught and "caught" is printed (exit 0).
Buggy: the COPY/TO_BOOL instructions inserted for the pseudo conditional jump lose their exception handler, so the exception escapes the try block (traceback, exit 1).
