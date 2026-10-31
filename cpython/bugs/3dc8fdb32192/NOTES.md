repro.py calls `frozendict.__init__(b=2)` on an existing frozendict.
The injection gives frozendict `tp_init = dict_init`, so `__init__` tries to mutate it.
Clean: `__init__` is a harmless no-op, prints `frozendict({'a': 1})`, exit 0.
Buggy: debug assertion `can_modify_dict: !_PyObject_GC_IS_TRACKED(mp)` fails, abort (exit -6).
