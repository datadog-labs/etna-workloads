# Rationale

**Bug:** An invalid `main` entry in package.json (file doesn't exist) is silently ignored. Node falls back to `index.js` with no DEP0128 deprecation warning, and if no index exists it throws a generic `Cannot find module '<request>'` instead of one naming the bad `main` (without `path`/`requestPath`).

**Change (lib/internal/modules/cjs/loader.js)**
- `tryPackage` (fix hunk 2): restored the pre-fix body: return `false` if there is no `main`, otherwise return `tryFile || tryExtensions || tryExtensions(index)` of the main. Removed the "actual === false" branch that threw the MODULE_NOT_FOUND error and emitted the DEP0128 warning.
- `Module._findPath` (fix hunk 3): restored the `index` fallback after `tryPackage` returns falsy (the fix moved it into tryPackage).
- (The fix's `pendingDeprecation` constant hunk doesn't exist in today's code; the warning is unconditional there and was removed with the branch above.)

**Failing tests**
- sequential/test-module-loading: assert.throws for missing-main-no-index gets message "Cannot find module '../fixtures/packages/missing-main-no-index'" rather than the expected "...doesnotexist.js'. Please ... valid "main"".
- parallel/test-module-loading-deprecated: fails (expected DEP0128 warning is never emitted).
- parallel/test-require-exceptions still passes.
