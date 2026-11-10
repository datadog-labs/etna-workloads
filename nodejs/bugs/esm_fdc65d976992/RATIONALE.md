# Re-introduced bug: ESM import of CJS with circular requires loads module twice

**Bug.** When ESM imports a CJS module that takes part in a require cycle (a -> b -> a), the ESM translator loaded the module via `module.load(filename)` on the pre-created cache entry rather than through the CJS loader's `Module._load` path. That path honours the cache and the in-progress state, so the cycle is handled. With the direct `module.load`, the module body is evaluated a second time: `recursive-a.cjs` ran twice and `global.counter` was 2 instead of 1.

**Hunk (lib/internal/modules/esm/translators.js, `loadCJSModuleWithModuleLoad`).** The fix replaced `module.load(filename)` with `assert(module === CJSModule._cache[filename]); CJSModule._load(filename);`. In today's code the equivalent is the `wrapModuleLoad(...)` call (the descendant of `Module._load`), with its two branches. I replaced those branches with `module.load(filename); exports = module.exports;`, which restores the pre-fix direct `module.load` call. The existing assert on the cache entry is left in place, since it was already there.

**Failing test.** `es-module/test-esm-recursive-cjs-dependencies` fails (`not ok`) with `AssertionError: Expected values to be strictly equal: 2 !== 1` at the `strictEqual(global.counter, 1)` line. I ran it twice and it failed both times.
