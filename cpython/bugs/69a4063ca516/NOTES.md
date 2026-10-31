Setting `type.__module__` should drop the class's `__firstlineno__` from its dict
(the line number is no longer meaningful for the new module). The injection removes
that pop in `type_set_module`.

repro.py defines a class, sets `C.__module__`, and prints whether `__firstlineno__`
is still in `vars(C)`. Clean: `True` then `False`. Buggy: `True` then `True`.
