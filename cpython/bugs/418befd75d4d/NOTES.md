Reproducer: instantiates a `property` subclass with `__slots__` (no `__dict__`), with no args and with `doc=`.
Clean: both succeed (the AttributeError from setting `__doc__` is silently ignored).
Buggy: AttributeError is raised from the constructor (gh-98963 regression).
