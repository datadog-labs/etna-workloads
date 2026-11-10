# Re-introduced bug (nodejs 24bf1adacc)

**Bug:** If `module.exports` is a Proxy (with getPrototypeOf/setPrototypeOf traps) in a circular require, the loader's own circular-dependency check (`ObjectGetPrototypeOf` / `ObjectSetPrototypeOf`) triggers those traps, which throw or misbehave.

**Hunks (lib/internal/modules/cjs/loader.js):**
1. `getExportsForCircularRequire`: removed `!isProxy(module.exports) &&` (fix hunk adding it), so the prototype is read/replaced on proxies.
2. `Module._load` cleanup branch: removed `!isProxy(module.exports) &&`, so the prototype is read on proxies again.
(The fix's import hunk is left in place; `isProxy` is imported already in today's code, now unused here.)

**Failing test:** parallel/test-module-circular-dependency-warning — `not ok` (stable over 2 runs); the proxy fixture's `getPrototypeOf` trap throws an Error during require.
