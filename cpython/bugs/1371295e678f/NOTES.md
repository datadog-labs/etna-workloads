Reproducer: `yield from` on an object whose `__iter__` raises (gh-126366).
Clean interpreter prints `RuntimeError: nobody expects the spanish inquisition`.
The buggy one no longer checks for a NULL result from `PyObject_GetIter` in the
yield-from iterator setup (ceval.c), so it crashes or hits an assertion instead
of propagating the exception.
