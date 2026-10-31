repro.py creates a subinterpreter and imports `_testsinglephase_raise_exception`
(a single-phase extension whose PyInit raises RuntimeError("evil")) from it.

Clean: the error is reported as an unraisable exception and the subinterpreter
gets `ImportError: failed to import from subinterpreter due to exception`; exit 0.
Buggy: the exception object is shared across interpreters, which corrupts memory
and the process crashes with SIGSEGV (exit -11).
