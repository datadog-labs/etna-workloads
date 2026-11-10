# Re-introduced bug
Synchronous module jobs (ModuleJobSync, used for require(esm)) are no longer stored in the loadCache
before linking. With an ESM<->ESM cycle in a require()'d graph (a.mjs <-> b.mjs), the cycle cannot be
resolved from the cached job, so each link creates a new ModuleJobSync for the same module, recursing
infinitely: `RangeError: Maximum call stack size exceeded`.

# Change (lib/internal/modules/esm/module_job.js, `syncLink`)
Corresponds to the fix's module_job.js hunk (in today's code the logic lives in syncLink):
- Removed the `loadCache.set(this.url, this.type, this)` before linking (and the hadPreviousEntry
  bookkeeping): the pre-fix behaviour of not caching before linking.
- Removed the `finally` cleanup `loadCache.delete(...)`, which only makes sense with the pre-link set.
The module_map.js `delete` hunk is left in place (harmless, unused now; the fix added it alongside).

# Failing test
es-module/test-require-module-cycle-cjs-esm-esm: `RangeError: Maximum call stack size exceeded`
at ModuleJobSync.syncLink. Failure observed on repeated runs.
