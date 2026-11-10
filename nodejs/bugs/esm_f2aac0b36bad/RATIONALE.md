# Re-introduced bug: ESM loader vulnerable to prototype pollution

Internal ESM loader results (plain objects returned from async functions / awaited) and the
ModuleWrap class inherited from Object.prototype, so user-defined `Object.prototype.then`
getters/setters were hit when the loader's promises resolved with those objects.

## Hunks
- lib/internal/bootstrap/realm.js: removed `ObjectSetPrototypeOf(ModuleWrap.prototype, null)` (and the
  now-unused import). Corresponds to the loaders.js `getESMFacade` hunk (code moved to realm.js since).
- lib/internal/modules/esm/load.js: `getSource` return and `defaultLoad` return lose `__proto__: null`
  (fix hunks in load.js).
- lib/internal/modules/esm/module_job.js: `run`-style `return { module: this.module }` loses `__proto__: null`.
- lib/internal/modules/esm/resolve.js: `data:` early return in defaultResolve loses `__proto__: null`.
(The loader.js hunks were not reverted; the omitted ones are redundant for the oracle.)

## Failing tests
es-module/test-cjs-prototype-pollution and es-module/test-esm-prototype-pollution fail
(`not ok`) because `import('data:text/javascript,')` touches Object.prototype.then (mustNotCall).
parallel/test-primordials-promise still passes.
