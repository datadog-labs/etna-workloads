Reproducer: defines `class __Base` and `class Derived[T](__Base, __kwarg=1)` via exec at module level.
Names in the bases/keywords of a generic class must not be mangled. Clean prints `True {'__kwarg': 1}`;
buggy mangles them (NameError for `_Derived__Base` / kwarg `_Derived__kwarg`).
