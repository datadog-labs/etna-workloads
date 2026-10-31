Reproducer for gh-118272: `generator.close()` must release the frame's locals.
A suspended generator holds a local `a` referencing a Foo; after the global is deleted and `g.close()` is called, a weakref to the Foo should be dead.
Clean prints `True`; buggy prints `False` (locals are kept alive by the closed generator).
