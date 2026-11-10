# Re-introduced bug: rekeying source map on a primitive thrown value (c5cc3d4a8b22)

## Bug
When source maps are enabled and a CJS module throws while loading, `Module._load` catches the
error and "rekeys" the module's source-map entry onto the error object (the module itself is
about to be dropped). If the thrown value is a primitive (e.g. `throw 'goodbye'`), it can't be
used as a weak/object key, so the rekey itself throws `TypeError: WeakRef: invalid target`,
masking the user's error.

## Changes (the fix's hunks, reversed and re-expressed for the current code)
The current code no longer has `rekeySourceMap` / `cjsSourceMapCache` (WeakMap); the cache is a
`SourceMapCacheMap` using WeakRefs and a private symbol.
1. `lib/internal/modules/cjs/loader.js`, `Module._load` (fix hunk 1, the removal of the
   try/catch): restored the `if (getSourceMapsSupport().enabled) { try { module.load } catch (err)
   { rekeySourceMap(Module._cache[filename], err); throw err; } }` block, and the imports
   (`getSourceMapsEnabled` is now `getSourceMapsSupport().enabled`).
2. `lib/internal/source_map/source_map_cache.js` (fix hunk 2, removal of `rekeySourceMap`):
   re-added and exported `rekeySourceMap`. It finds the module's entry and attaches it to the
   new instance via `new SafeWeakRef(newInstance)` + the private symbol (as the cache map does
   for modules); the WeakRef construction throws TypeError for primitives, as the old WeakMap
   `set` did. Added the `SafeWeakRef` and `source_map_data_private_symbol` imports.

## Failing test
`parallel/test-source-map-enable` fails (stable on repeated runs). The TAP failure reported is the
`webpack.js` case (`The input did not match the regular expression /throw new Error\('oh no!'\)\r?\n.*\^/`):
the rethrow in `_load` (carrying `node-do-not-add-exception-line`, as in the original code) suppresses the
source-mapped arrow message for uncaught errors in this release, so that earlier case fails first and
masks the later one. This is a side effect of restoring the catch/rethrow. The intended defect
is also present: `node --enable-source-maps test/fixtures/source-map/throw-string.js` prints
`TypeError: WeakRef: invalid target at rekeySourceMap` instead of `goodbye`, which is what the
fix's new test case (throw-string) checks.
