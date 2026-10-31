Creates dataclass(slots=True) subclasses of `_testcapi.HeapCTypeWithDict` and `HeapCTypeWithWeakref`, each declaring a `__dict__` field, and prints `__slots__`.

Clean: `()` and `('__dict__',)`. Buggy: `()` and `()`, because `_get_slots` checks the nonexistent `__dictrefoffset__` and so never adds `__dict__` for a parent without a dict offset.
