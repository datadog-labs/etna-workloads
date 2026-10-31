Subclasses cached_property with a `__set__` (making it a data descriptor, so the
cache in the instance `__dict__` never short-circuits lookup). Reads `t.prop`,
changes `_prop`, reads again. Clean: prints 1, 1 (`__get__` checks the instance
dict). Buggy: prints 1, 999 (`__get__` recomputes every time).
