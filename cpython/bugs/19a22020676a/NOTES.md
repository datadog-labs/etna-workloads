repro.py lazily loads a module that sets its own `__class__` to a ModuleType subclass whose `__setattr__` raises AttributeError (PEP 726 style).
Clean: first attribute access works (prints 3.14), the class stays ImmutableModule, and later assignment raises AttributeError.
Buggy: _LazyModule.__getattribute__ does `self.__class__ = types.ModuleType` after loading, which goes through the module's own `__setattr__`, so `module.CONSTANT` raises AttributeError('Read-only attribute!').
