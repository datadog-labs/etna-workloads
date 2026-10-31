Reproducer: `inspect.getdoc()` on a `functools.cached_property` whose docstring is
inherited from a parent class (the child doesn't redefine it, or redefines it without a docstring).
Clean: prints the parent's docstring for P.foo, C.foo and D.foo.
Buggy: D.foo gives None (the redefined, undocumented one), because `_finddoc` no longer handles cached_property.
