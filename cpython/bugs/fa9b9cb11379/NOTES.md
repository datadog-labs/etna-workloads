repro.py creates `@dataclass(slots=True, weakref_slot=True)` on a class deriving from `typing.Generic[T]`, which already has `__weakref__`/`__dict__` slots from the base.

- clean: prints `('__weakref__',)` and `True`, and `A()` works.
- buggy: `_get_slots` yields `('__dict__', '__weakref__')` for bases without `__slots__`, so the base's `__dict__`/`__weakref__` slots get excluded wrongly. The script then fails with `AttributeError: type object 'A' has no attribute '__weakref__'`.

(`./check.sh` fails in this sandbox with a bwrap error, so I ran both interpreters by hand.)
