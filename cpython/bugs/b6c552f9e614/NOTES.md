Creates a class via `type()` with a tuple subclass instance as `bases` (gh-132176).
Clean: prints `(<class 'int'>, <class 'object'>) TupleSubclass`.
Buggy: debug build hits `assert(PyTuple_CheckExact(bases))` in set_tp_bases and aborts.
