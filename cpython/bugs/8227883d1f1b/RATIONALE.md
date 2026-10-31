# gh-118013: strong refs in inspect._shadowed_dict cache key

Changed only `Lib/inspect.py`.

- Fix hunk: `_shadowed_dict_from_mro_tuple(mro)` -> `_shadowed_dict_from_weakref_mro_tuple(*weakref_mro)` (lru_cache keyed on weakrefs). Reversed: restored the lru_cache'd `_shadowed_dict_from_mro_tuple(mro)` iterating `entry in mro` directly.
- Fix hunk: `_shadowed_dict` wrapping each MRO entry in `make_weakref`. Reversed: it passes `_static_getmro(klass)` (strong refs) as the cache key again, so the lru_cache keeps dynamically created classes alive.
- Added one alias line `_shadowed_dict_from_weakref_mro_tuple = _shadowed_dict_from_mro_tuple`, solely because the unchanged `Lib/test/libregrtest/utils.py` `clear_caches()` calls that name; without it every test errors. The `make_weakref` import is left (harmless, it is used elsewhere in the module? unused otherwise).

Oracle failure: `TestGetattrStatic.test_cache_does_not_cause_classes_to_persist` fails with `AssertionError: <class ...Foo> is not None` (class kept alive by the cache). The other 381 cases pass.
