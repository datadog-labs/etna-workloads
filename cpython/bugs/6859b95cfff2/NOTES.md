Creates a `@dataclass(slots=True)` class with an annotated field inside a function, runs gc, and counts
`SlotsTest` classes in `object.__subclasses__()`. Clean: 1 (original class collected). Buggy: 2, because
the injection makes `__dict__`/`__weakref__` descriptors per-type again, so the original class stays alive.
