# Rationale

Fix hunk (Lib/linecache.py, `lazycache`): the module name used for `loader.get_source()` was
changed from `module_globals['__name__']` to `getattr(spec, 'name', None) or module_globals['__name__']`.

In v3.15.2 the same logic lives in `_make_lazycache_entry` (Lib/linecache.py). I reverted the
`spec = module_globals.get('__spec__')` / `name = getattr(spec, 'name', None) or ...` lines to
`name = module_globals['__name__']`, which is the pre-fix computation. The loader selection
(`_bless_my_loader`) was rewritten later and is left unchanged.

Oracle failure: `test.test_linecache.LineCacheTests.test_loader` fails. With `__spec__` named
`x.y.z` and `__name__` `a.b.c`, the source is fetched for `a.b.c` instead of `x.y.z`.
