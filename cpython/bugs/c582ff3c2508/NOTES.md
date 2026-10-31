`repro.py` calls `fromkeys` on a `frozendict` subclass whose `__new__` returns an existing, GC-tracked frozendict (the upstream `test_fromkeys` case).

- Clean: `fromkeys` works on a copy, prints `frozendict({'x': 1})` twice, and exits 0.
- Buggy: the copy step is removed, so the shared frozendict is modified directly. The debug assert `!_PyObject_GC_IS_TRACKED(mp)` in `can_modify_dict` fails and the process aborts (exit -6).
