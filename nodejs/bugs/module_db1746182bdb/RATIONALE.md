# Re-introduced bug

Fix: db1746182b "module: disallow CJS <-> ESM edges in a cycle from require(esm)".

## Bug
When an ESM module (evaluated via import) imports a CJS module that in turn `require()`s an ESM
module in the same cycle, the cycle is no longer detected on the CJS<->ESM edge. The loader does not
throw `ERR_REQUIRE_CYCLE_MODULE` ("Cannot import CommonJS Module ./x.cjs in a cycle. (from ...)"),
so such cycles proceed (or fail differently) instead of being rejected.

## Change (one hunk, lib/internal/modules/esm/loader.js)
Corresponds to the fix hunk in `ModuleLoader#getModuleJobForRequire` (then `getModuleJobForRequire`
body) that added `const cjsModule = wrap[imported_cjs_symbol]; if (cjsModule?.[kIsExecuting]) throw
new ERR_REQUIRE_CYCLE_MODULE('Cannot import CommonJS Module ... in a cycle ...')`. I removed that
block (and the now-unused `kIsExecuting` / `imported_cjs_symbol` imports, matching the fix's
import hunks), restoring the pre-fix behaviour where this edge was unchecked.

## Failing tests
- es-module/test-require-module-cycle-esm-cjs-esm
- es-module/test-require-module-cycle-esm-cjs-esm-esm
- es-module/test-require-module-cycle-esm-esm-cjs-esm-esm

They expect stderr matching `/Cannot import CommonJS Module \.\/b\.cjs in a cycle\. \(from .*a\.mjs\)/`
(etc.); that message is no longer produced. (esm-esm-cjs-esm still passes.) Stable across two runs.
