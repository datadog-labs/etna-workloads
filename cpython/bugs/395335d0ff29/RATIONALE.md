# Rationale

v3.15.2 already contains the fix's `_singledispatchmethod_get` class, so the
fix hunks cannot be reversed literally. The bug was the removed
`_method_cache` (a `WeakKeyDictionary` keyed on `obj`), so it is restored in
`Lib/functools.py`:

- `singledispatchmethod.__init__`: re-adds `self._method_cache = weakref.WeakKeyDictionary()`
  (reverses the removal hunk in `__init__`).
- `singledispatchmethod.__get__`: re-adds the cache lookup/store around the
  bound object, as in the pre-fix `__get__`. It now stores the
  `_singledispatchmethod_get` object, which holds `obj` strongly. The cached
  value references its own key, so the weak key never dies (leak/loop), equal
  instances share one entry (wrong `self` returned), and unhashable or bad-hash
  objects hit `__hash__`/`__eq__`.

Failing oracle cases (TestSingleDispatch):
- `test_method_equal_instances`: `b.t(2)` returns `a`.
- `test_method_bad_hash`: `__hash__`/`__eq__` is called, so AssertionError is raised.
- `test_method_no_reference_loops`: the instance stays alive after `del a`.
